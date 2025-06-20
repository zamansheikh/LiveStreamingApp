import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:streaming_djlive/components/custom_widgets/custom_text_form_field.dart';

import '../../../../components/utilities/chat_theme.dart';
import '../bloc/log_in_bloc/log_in_bloc.dart';

class ProfileSignupComplete extends StatefulWidget {
  ProfileSignupComplete({super.key});

  @override
  State<ProfileSignupComplete> createState() => _ProfileSignupCompleteState();
}

class _ProfileSignupCompleteState extends State<ProfileSignupComplete> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  String selectedFlag = '';
  String? selectedCountry;
  List<String>? selectedLanguage;
  String? countryDialCode;
  String? countryIsoCode;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUidAndDispatchEvent();
      isFormComplete();
    });
    super.initState();
  }

  Future<void> _loadUidAndDispatchEvent() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('uid');

    if (uid != null && uid.isNotEmpty) {
      print("Userid: $uid");
      context.read<LogInBloc>().add(LogInEvent.profileDataLoad(uId: uid));
    } else {
      print("No UID found");
    }
  }

  bool isFormComplete() {
    final result = context.read<LogInBloc>().state.userInfoProfile.result;
    //  final result = state.userInfoProfile.result;
    if (result == null) return false;
    print('Result: $result');
    print('Result First Name: "${result.firstName}"');
    print('Result Last Name: "${result.lastName}"');
    print('Result Birthday: ${result.birthday}');
    print('Result Bio: "${result.bio}"');
    print('Result Bio: "${result.country}"');

    return (_firstNameController.text.isNotEmpty) &&
        (_lastNameController.text.isNotEmpty) &&
        (_genderController.text.isNotEmpty) &&
        (selectedCountry!.isNotEmpty) &&
        (_birthdayController.text.isNotEmpty);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthdayController.text.isNotEmpty
          ? DateFormat('yyyy-MM-dd').parse(_birthdayController.text)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      context.read<LogInBloc>().add(LogInEvent.birthDayChanged(
          birthDay: DateFormat('yyyy-MM-dd').format(picked).toString()));
      _birthdayController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LogInBloc, LogInState>(
        // listenWhen: (previous, current) =>
        //     previous.userInfoProfile.result != current.userInfoProfile.result,
        listenWhen: (previous, current) =>
            previous.userInfoProfile != current.userInfoProfile,
        listener: (context, state) async {
          final result = state.userInfoProfile.result;

          if (result != null) {
            _firstNameController.text = result.firstName ?? '';
            _lastNameController.text = result.lastName ?? '';
            _bioController.text = result.bio ?? 'Welcome to StreamBird';
            _birthdayController.text = result.birthday ?? '';

            if ((result.firstName?.isNotEmpty ?? false) &&
                (result.lastName?.isNotEmpty ?? false) &&
                // (result.bio?.isNotEmpty ?? true) &&
                (result.country?.isNotEmpty ?? false)) {
              context.go('/home');
            }
          }
        },
        child: BlocBuilder<LogInBloc, LogInState>(
          builder: (context, state) {
            // _firstNameController.text =
            //     state.userInfoProfile.result?.firstName ?? "";
            // _lastNameController.text =
            //     state.userInfoProfile.result?.lastName ?? "";
            // _bioController.text =
            //     state.userInfoProfile.result?.bio ?? 'Welcome to StreamBird';
            // _birthdayController.text =
            //     state.userInfoProfile.result?.birthday ?? '';
            final userProfile = state.userInfoProfile.result;

            print('Is form complete? ${isFormComplete()}');
            if (userProfile == null) {
              return Column(
                children: [
                  SizedBox(height: 30.sp),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/new_images/ic_logo_white.png',
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(width: 8.sp),
                        Text(
                          "StreamBird",
                          style: MyTheme.kAppTitle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 74.sp,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      padding: EdgeInsets.symmetric(horizontal: 16.sp),
                      itemBuilder: (_, __) => Padding(
                        padding: EdgeInsets.only(right: 12.sp),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Column(
                            children: [
                              Container(
                                height: 42.sp,
                                width: 42.sp,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(height: 6.sp),
                              Container(
                                height: 10.sp,
                                width: 40.sp,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.sp)
                          .add(EdgeInsets.only(bottom: 80.sp)),
                      itemCount: 6,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 0.sp,
                        crossAxisSpacing: 10.sp,
                        childAspectRatio: 0.70,
                      ),
                      itemBuilder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 180.sp,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Stack(
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Image.asset(
                      "assets/images/new_images/profile-bg.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60.sp,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 18.0),
                          child: Text(
                            'Complete your personal data',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 18.0),
                          child: Text(
                            'For better experience',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 25.sp),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            height: 458.sp,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: 14.sp, left: 14.sp),
                                child: ListView(
                                  children: [
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      controller: _firstNameController,
                                      hintText: "First Name",
                                      validator: (value) {
                                        if (_firstNameController.text.isEmpty) {
                                          return 'Please enter your first name';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        _firstNameController.text = value;
                                        // context
                                        //     .read<LogInBloc>()
                                        //     .add(LogInEvent.firstNameChanged(
                                        //       firstName: value,
                                        //     ));
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      controller: _lastNameController,
                                      hintText: "Last Name",
                                      validator: (value) {
                                        if (_lastNameController.text.isEmpty) {
                                          return 'Please enter your last name';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        _lastNameController.text = value;
                                        // context
                                        //     .read<LogInBloc>()
                                        //     .add(LogInEvent.lastNameChanged(
                                        //       lastName: value,
                                        //     ));
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    CustomTextField(
                                      controller: _bioController,
                                      hintText: "Bio",
                                      maxLength: 200,
                                      validator: (value) {
                                        if (_bioController.text.isEmpty) {
                                          return 'Please enter your bio';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        _bioController.text = value;
                                        // context
                                        //     .read<LogInBloc>()
                                        //     .add(LogInEvent.bioChanged(
                                        //       bio: value,
                                        //     ));
                                      },
                                    ),
                                    const SizedBox(height: 4),
                                    InkWell(
                                      onTap: () => _selectDate(context),
                                      child: IgnorePointer(
                                        child: TextFormField(
                                          controller: _birthdayController,
                                          decoration: InputDecoration(
                                            fillColor: Colors.grey.shade200,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.sp),
                                              borderSide: BorderSide(
                                                  width: 1.w,
                                                  color: Colors.grey.shade200),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.sp),
                                              borderSide: BorderSide(
                                                  width: 1.w,
                                                  color: Colors.grey.shade200),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16.sp),
                                              borderSide: BorderSide(
                                                  width: 1.w,
                                                  color: Colors.red),
                                            ),
                                            hintText: 'YYYY-MM-DD',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your birthday';
                                            }
                                            try {
                                              DateFormat('yyyy-MM-dd')
                                                  .parse(value);
                                            } catch (e) {
                                              return 'Please enter a valid date in YYYY-MM-DD format';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        fillColor: Colors.grey.shade200,
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.sp),
                                          borderSide: BorderSide(
                                              width: 1.w,
                                              color: Colors.grey.shade200),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.sp),
                                          borderSide: BorderSide(
                                              width: 1.w,
                                              color: Colors.grey.shade200),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.sp),
                                          borderSide: BorderSide(
                                              width: 1.w, color: Colors.red),
                                        ),
                                        hintText: 'Select Gender',
                                      ),
                                      value: state
                                          .userProfile.result?.first.gender,
                                      items: [
                                        DropdownMenuItem(
                                          value: 'Male',
                                          child: const Text('Male'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Female',
                                          child: Text('Female'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        _genderController.text = value ?? "";
                                        // context.read<LogInBloc>().add(
                                        //     LogInEvent.genderChanged(
                                        //         gender: value ?? ''));
                                      },
                                      validator: (value) {
                                        if (_genderController.text.isEmpty) {
                                          return 'Please select a gender';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 6.sp),
                                    GestureDetector(
                                      onTap: () {
                                        showCountryPicker(
                                          context: context,
                                          showPhoneCode: true,
                                          onSelect: (Country country) {
                                            setState(() {
                                              selectedCountry = country.name;
                                              selectedLanguage = [country.name];
                                              selectedFlag = country.flagEmoji;
                                              countryDialCode =
                                                  country.phoneCode;
                                              countryIsoCode =
                                                  country.countryCode;
                                            });
                                            // Dispatch event to update country details
                                            // context.read<LogInBloc>().add(
                                            //       LogInEvent.countryChanged(
                                            //         countryName:
                                            //             country.flagEmoji,
                                            //         countryDialCode:
                                            //             country.phoneCode,
                                            //         countryFlag:
                                            //             country.flagEmoji,
                                            //         countryIsoCode:
                                            //             country.countryCode,
                                            //         countryLanguages: [
                                            //           country.name
                                            //         ],
                                            //       ),
                                            //     );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.h, horizontal: 12.w),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(16.sp),
                                        ),
                                        child: Row(
                                          children: [
                                            if ((selectedCountry?.isNotEmpty ??
                                                false)) ...[
                                              Text(
                                                selectedFlag!,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.sp,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                selectedCountry ?? '',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ] else
                                              Text(
                                                "Select Country",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            Spacer(),
                                            Icon(Icons.arrow_drop_down),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6.sp),
                        Padding(
                          padding: EdgeInsets.only(left: 15.sp, right: 15.sp),
                          child: SizedBox(
                            width: double.infinity,
                            height: 40.h,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.red;
                                  }
                                  return const Color(
                                      0xff2c3968); // Default blue when enabled
                                }),
                              ),
                              onPressed: isFormComplete()
                                  ? () {
                                      context
                                          .read<LogInBloc>()
                                          .add(
                                              LogInEvent.saveUserProfile(
                                                  context: context,
                                                  firstName:
                                                      _firstNameController.text,
                                                  lastName:
                                                      _lastNameController.text,
                                                  birthday:
                                                      _birthdayController.text,
                                                  gender:
                                                      _genderController.text,
                                                  bio: _bioController.text,
                                                  countryName: selectedCountry
                                                      .toString(),
                                                  countryDialCode:
                                                      countryDialCode
                                                          .toString(),
                                                  countryIsoCode:
                                                      countryIsoCode.toString(),
                                                  countryLanguages: [
                                                countryIsoCode.toString()
                                              ]));
                                    }
                                  : null,
                              child: /*state.profileSaveStatus ==
                                      ProfileSaveStatus.inProgress
                                  ? const Center(
                                      child:
                                          CircularProgressIndicator.adaptive())
                                  :*/
                                  Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.sp),
                        GestureDetector(
                          onTap: () {
                            // context.read<LoginInfo>().logout();
                            // context.pop();
                            // context.go("/welcome-screen");
                          },
                          child: Center(
                            child: Text(
                              '“Cannot chane gender and country after confirmation”',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 110.sp,
                      left: 150.sp,
                      child: GestureDetector(
                        onTap: () {
                          // context.pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                contentPadding: EdgeInsets.zero,
                                titlePadding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.white),
                                ),
                                title: SizedBox(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24.sp, vertical: 20.sp),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Update Image",
                                              style:
                                                  GoogleFonts.notoSansBengali(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                context.pop();
                                              },
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.black,
                                                size: 14.sp,
                                                weight: 10.w,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                        color: Color(0xffE0E0DD),
                                      ),
                                    ],
                                  ),
                                ),
                                content: Container(
                                  alignment: Alignment.center,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.sp),
                                  height: 88.h,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 40.h,
                                        child: GestureDetector(
                                          onTap: () {
                                            context.pop();
                                            context
                                                .read<LogInBloc>()
                                                .add(LogInEvent.imagePicked(
                                                  cameraImage: true,
                                                  context: context,
                                                ));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 12.w,
                                              ),
                                              Text(
                                                "From Camera",
                                                style:
                                                    GoogleFonts.notoSansBengali(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11.sp,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 1.h,
                                        color: const Color(0xffE0E0DD),
                                      ),
                                      SizedBox(
                                        height: 40.h,
                                        child: GestureDetector(
                                          onTap: () {
                                            context.pop();
                                            context.read<LogInBloc>().add(
                                                LogInEvent.imagePicked(
                                                    cameraImage: false,
                                                    context: context));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 12.w,
                                              ),
                                              Text(
                                                "From Gallery",
                                                style:
                                                    GoogleFonts.notoSansBengali(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11.sp,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            state.pickedImageFile != null
                                ? CircleAvatar(
                                    radius: 32.r,
                                    // Size of the avatar
                                    backgroundImage: FileImage(File(
                                        state.pickedImageFile?.path ?? "")),
                                    // Image URL
                                    backgroundColor: Colors
                                        .grey[200], // Fallback background color
                                  )
                                : userProfile?.avatar != null
                                    ? CircleAvatar(
                                        radius: 32.r,
                                        // Size of the avatar
                                        backgroundImage: NetworkImage(
                                          userProfile?.avatar?.url ?? '',
                                        ),
                                        // Image URL
                                        backgroundColor: Colors.grey[
                                            200], // Fallback background color
                                      )
                                    : CircleAvatar(
                                        radius: 32.r, // Size of the avatar
                                        backgroundImage: const AssetImage(
                                            'assets/images/new_images/profile.png'),
                                      ),
                            Positioned(
                                top: 2,
                                right: 2,
                                child: CircleAvatar(
                                    radius: 10.r,
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      Icons.edit,
                                      size: 13.sp,
                                      color: Colors.white,
                                    ))),
                          ],
                        ),
                      )),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
