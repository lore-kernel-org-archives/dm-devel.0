Received: from sonic310-20.consmr.mail.gq1.yahoo.com (sonic310-20.consmr.mail.gq1.yahoo.com [98.137.69.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953DD33B6FF
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 08:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=98.137.69.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763715119; cv=none; b=ZvpdekIx9eUI8g08GO6A6EGKaoQJJUrtAb5fmn0GwZmuualTn9nby9+8DSyeKvP61xbS/FfCCncFgo3uhlJyW3v+3dh5LbxjHYK2cLgucS1ZL1RKqK+zKze7H0ttylNjzSisowOIaA2OwqxBjV76AvFh5+izeJGP17CSnT/zNNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763715119; c=relaxed/simple;
	bh=VQA1zWoRmvzNAIoJgYI2w4QJJ9ApSmpTmsUQRsvNafE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LZqhQQHFJjAI02Xj2hWZQIB0DBC+PV/vsvnxKVRHZLqcEBdJKDfMAGTdGGY0XXptn1Rvx3eir96+dzZwMSN4Xm4rZ8t+xYeju4N/rJ+4mpl8OpiJKY+b4TPF14ivq4SxieqwhgYEpSRNXHa2gl9n/O2hn2o3acIRgQYs0VWmqDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=axew00HI; arc=none smtp.client-ip=98.137.69.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="axew00HI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1763715116; bh=fyS3l5uy8qus9T52UCdu8oTaaXewmgtMdQXy0DG1Xug=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=axew00HICpPkKxBmIy1u4XCpZ6+Pz0q8EkJJkLvf8IIAHTACqogj66G9/AlPdBPXz5KJ9BpO/K0X53fLlMQqWFeggDh7AUZlRJT7Ru5McjUBvfiFsGNg+jk4TRv6Tt3s/AtnwyYEODB4MH5zNjy9imZclD/ofryoxSpOLPmbvzBTyiQ6silM/S5cmVFEuxh/OoaoqujlgFFCKZVLI0HSj+tXh3+7V61SAMWPIQ44hzATx2s4EaiCdeX6hRbrEZW8XcbwYTgDzEgPmn4Vx0d2UnEHOSJIVmK9BM0pwt+JDRsfd4rJxu1zTVkpgX9StP2lVp7sT/x5NXjjGAL9guGZYA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1763715116; bh=7fyPxgnd1XubSEXF/HZhAnaqcSzXG4EIzzr5j8Ufh2Q=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=rfNZ3xJhO8hnpyPewGfCd0bHKGK3+1yth5JPNFNtdTkcAh/fnLeg6PKaX9l8NjMVIsixuKngCPU1bKOGEKP+82i7kEtjEHdT1K9vwu4JrB2oQNMFlrNww9PKmds394lJBuI8FFX/mV8gTnIMGAuTHiIHQ2oG62LgXx07sJmj22HrHlf4ptvJzO1uPc3roFcMrcv6MRMdydDzFKX1DFjVaHBFLahb4NtOtAZs/ExbYHdjhsTLKiY2fI99W+kYMU1KuQAvmbBxONqn1hWyKNGzS3hTyc6u3qNaHYEobTXZC3nMGzjBGa8YdjPYD2Zrj9g4MHxYl8njzNXyXiglL6HTdA==
X-YMail-OSG: s9QpALEVM1lUsUqZjPsXR.G0usJD14E8olM3WttPmbZ7btCQm09qnh6dClLhTDF
 6KIg.D9S2EMrSSu2YAHh5xwwEs73QGKEHGhEu9ZroeltIocjUrVvUvGmIe9nAY6man7vJdlW3n0A
 OcDMpD2eTT_p4JY9Oq3bobc9_eduEkEq21jh5Zi2N5OvZ7DBis9DnEf0ACd_FojVY4h6C6AzjVJO
 XYWqvcLXoTnzaDGGmsiT9ZHBCOmWO6iHAcphoel0G7YRg2CV94TTt0fzq6JrYMuC9Xvf1q72HhS9
 2KsfJ6sJ3AXsx69HGN.ywayDsWKMxk7fb3dWc.DKtisaD_5cBWbJ8rF.AjWca8MA60JcnE5aeTY2
 WlW0arekll8HwpmK2GfG7KRg0qDLOULkPZm6QfvZGbakhpnvowDHt8KUDW4ZaVWdLP.bYJrJ5fMc
 TjykcxMlgd6fI_b9o77ynbOmlST31locDKb6zSIi_ubgSqEgK6P4BqiCz5I2NsxAL6jLfT4vLUn8
 tCygRLlrNGnKIQP4SlO3ygMJz1qdWhAeoMkugL6qAjTR06S3KoHu19GbLWZQ62AQ_1J9I6dzoQPo
 OcTILWHwgmpV3lVkFnn_GCeM.ySB10hRfHrsduV3sIySQsZK7fW5ndAbrxP_IKCYHVPtDIX0NsjW
 FT9MgLmaDdqtm.uV0o_Eb4uuUAV.W44IsZcB.AUKGjS7rMA0xYp5ujgMEf398181UooM9jgvxLj4
 1Qkqlc6dBSiE5rm8yzRz2os1qFzvnLdqnFnxgnKW_K0MTJO1vzj8zlTa6bCffMB2GluNEgcOC3Tm
 nRBKN94TMs6d0LcU8I7g_Zr2MTyHaIlWx0ArCGW7Eb4iiXqdDStKMRbp8fpqqL76tdkVZaSKA.3s
 _z7dBRBATuUxuQhUSBiHz5htnvVOugHoNlyqDbbEIvnGTSWEcQMClZD6WfxwB7TEJWe6r.MFzcVT
 eytpWAevPOprPEPGXEkk1zH9kew3bpyCS_MqD.dBAJMfzUxBk2tcecFIkHplu57v1EUqhSM4f9N7
 2_RUvdyAw17Y2HtPpLXF6x6Kq5z0Bl7da43I2UEmPPn3gWfQfsCik4y4_b7iuPFnq1HTqRRoKkeZ
 sP_4K7_zZJIiYNxrqUde5_.MVIU5JL5S9uGy.79hUaud8nhwc16wQFtISMLvXcyyfnMR0ad0oDVY
 AakwVYXS6IeqGzYyFtSPNPqyJf1bVCsmkiJi._L3B12jNKU2OcrrQ7Pi04P6n.XYo9vlfJk_Lh_W
 X8xsuA2f_FuGH0Y_.lS7EZmU.j7v5VduLCTkQ1Dl1s81EVU43jtKrQ8k4Q1Ca3QDMrEANvm.RubY
 t5i3r54VoU1wfPUk0wa7pOrZvyEmAtXJ7MzXAbEVuSJBTubx6D8hDoVJt_vyuZNhnJ4Iu9LG0Z2w
 tTXJo0couSHz_EdDk6EZFYaCqgiUGNjsL26GJPSARqcuQkOkpr5ipxby5xnFJ0sR2.YKd2AeJ6.5
 bwA_umBKk8Dybz6eG5.DkSEmMpfqMe27PLI6toE61d6aJQUqYVIEj_Nk3g8ureW0poEzbN7IWao8
 956gqzyWpHoB6FCqXs1o9WL_pvRdpFUuh9KhUMFbPialOGnf3TastcjJBrTC1f.oOFbafgArgaLg
 uUOkAtNFdzfjhygZ2gq6L6rbwEFjcYYQrYeqEnO.1FRrhi4JssWf_mPDlRGiNodGerFak23_Pdqt
 YYja9JMSkOLJi7tQbQtirbBAmGBWw6diKh8QjciHuxT318YL__CF1lqVG9L3M2GX3q_glth26Add
 JhLnQxchxlFoDQTYM9tkVBAQs0fOlY8X7vy2kFEfrJ4e8NYKTNhxyUoAnqd1RqJJINi_N5eUwN2x
 Lel.x0ndRkIvEogNmWpiGAlzZ7d2fOHg7nh8tyiBi_Jtt5vyXM70txn5T66_UdM0Nx35TJAGZnP7
 _LTk0jY_CeelW4OPvmiYaBVim54C3vaxu7yGBGGB1Jj2SSCjsn3ucqc0A3BVgm9M7qUObndp.X0F
 oHDO68xKzyh_gNcKJftFxAYsul4_Y2Ai9wr3b24XEbhO5Axl2oluhu4OHs9m9FIxKbXgptGJIi5D
 l_t0XR0qFYsljgNwW9qihpeQ1dktatm2scYTHGMWJmo9FIuXHwE3uWQ.6ra6I.qm9vtezbDwj.jg
 LsJquxsY.xh93NJ.h_0R7Yp0wr.GtQq.lwhpmYhC8PBFcRdLnOMq_sginaM4yFEgFulhBwlWEzbh
 Q_O468rfPJsY3gyD00a9kWAc9ieT19NiKertZ_1d63Y2uDX6RqlyG_In9hpaqolYj2rjsNdxPi73
 eD9gfE_6Hjw--
X-Sonic-MF: <adelodunolaoluwa@yahoo.com>
X-Sonic-ID: d9724993-9469-4ef2-9515-7677a9a66930
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.gq1.yahoo.com with HTTP; Fri, 21 Nov 2025 08:51:56 +0000
Received: by hermes--production-bf1-694dc9467b-4brn8 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 15b8a34120abcd15ca4c19388788ee37;
          Fri, 21 Nov 2025 08:21:34 +0000 (UTC)
Message-ID: <bca056a8-d9ec-4409-8033-feececf42438@yahoo.com>
Date: Fri, 21 Nov 2025 09:20:20 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: vdo: fix kernel-doc warnings in admin-state.c
To: Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
 linux-kernel-mentees@lists.linuxfoundation.org
References: <20251120164734.7187-1-adelodunolaoluwa.ref@yahoo.com>
 <20251120164734.7187-1-adelodunolaoluwa@yahoo.com>
 <f384ab6d-ddab-493c-aa52-71d01addad9f@redhat.com>
Content-Language: en-US
From: Sunday Adelodun <adelodunolaoluwa@yahoo.com>
In-Reply-To: <f384ab6d-ddab-493c-aa52-71d01addad9f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.24794 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 11/21/25 03:31, Matthew Sakai wrote:
> On 11/20/25 11:47 AM, Sunday Adelodun wrote:
>> Several functions in admin-state.c were missing parameter descriptions
>> leading to multiple kernel-doc warnings during build.
>>
>> Update the affected comments by adding missing @state, @operation,
>> @waiter, @initiator, @result, and other parameter descriptions.
>>
>> No functional changes.
>
> I'm ambivalent about some of the new comments. But there are also a 
> lot more kerneldoc warnings in the dm-vdo target, and now that you've 
> pointed them out I think I'll try to fix them all up myself. It may 
> take me a day or two to get the patch out.
>
> Thanks for bringing this up.
> Matt
I saw all the kerneldoc warnings in dm-vdo but wanted to get your 
feedback on one first.
But since you said you would work on them, I will not bother again.

You are welcome.
>
>> Signed-off-by: Sunday Adelodun <adelodunolaoluwa@yahoo.com>
>> ---
>>   drivers/md/dm-vdo/admin-state.c | 74 ++++++++++++++++++++++-----------
>>   1 file changed, 49 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/md/dm-vdo/admin-state.c 
>> b/drivers/md/dm-vdo/admin-state.c
>> index 3f9dba525154..eedbe080f632 100644
>> --- a/drivers/md/dm-vdo/admin-state.c
>> +++ b/drivers/md/dm-vdo/admin-state.c
>> @@ -187,6 +187,8 @@ static const struct admin_state_code 
>> *get_next_state(const struct admin_state *s
>>     /**
>>    * vdo_finish_operation() - Finish the current operation.
>> + * @state: The admin_state object representing the current operation.
>> + * @result: The result code to pass to any waiting completion handler.
>>    *
>>    * Will notify the operation waiter if there is one. This method 
>> should be used for operations
>>    * started with vdo_start_operation(). For operations which were 
>> started with vdo_start_draining(),
>> @@ -214,8 +216,10 @@ bool vdo_finish_operation(struct admin_state 
>> *state, int result)
>>     /**
>>    * begin_operation() - Begin an operation if it may be started 
>> given the current state.
>> - * @waiter A completion to notify when the operation is complete; 
>> may be NULL.
>> - * @initiator The vdo_admin_initiator_fn to call if the operation 
>> may begin; may be NULL.
>> + * @state: The admin_state object representing the current 
>> administrative state.
>> + * @operation: The state code describing the operation to begin.
>> + * @waiter: A completion to notify when the operation is complete; 
>> may be NULL.
>> + * @initiator: The vdo_admin_initiator_fn to call if the operation 
>> may begin; may be NULL.
>>    *
>>    * Return: VDO_SUCCESS or an error.
>>    */
>> @@ -259,8 +263,10 @@ static int __must_check begin_operation(struct 
>> admin_state *state,
>>     /**
>>    * start_operation() - Start an operation if it may be started 
>> given the current state.
>> - * @waiter     A completion to notify when the operation is complete.
>> - * @initiator The vdo_admin_initiator_fn to call if the operation 
>> may begin; may be NULL.
>> + * @state: The admin_state object representing the current 
>> administrative state.
>> + * @operation: The state code describing the operation to begin.
>> + * @waiter:     A completion to notify when the operation is complete.
>> + * @initiator: The vdo_admin_initiator_fn to call if the operation 
>> may begin; may be NULL.
>>    *
>>    * Return: true if the operation was started.
>>    */
>> @@ -274,10 +280,10 @@ static inline bool __must_check 
>> start_operation(struct admin_state *state,
>>     /**
>>    * check_code() - Check the result of a state validation.
>> - * @valid true if the code is of an appropriate type.
>> - * @code The code which failed to be of the correct type.
>> - * @what What the code failed to be, for logging.
>> - * @waiter The completion to notify of the error; may be NULL.
>> + * @valid: true if the code is of an appropriate type.
>> + * @code: The code which failed to be of the correct type.
>> + * @what: What the code failed to be, for logging.
>> + * @waiter: The completion to notify of the error; may be NULL.
>>    *
>>    * If the result failed, log an invalid state error and, if there 
>> is a waiter, notify it.
>>    *
>> @@ -301,7 +307,8 @@ static bool check_code(bool valid, const struct 
>> admin_state_code *code, const ch
>>     /**
>>    * assert_vdo_drain_operation() - Check that an operation is a drain.
>> - * @waiter The completion to finish with an error if the operation 
>> is not a drain.
>> + * @operation: The drain operation type to check.
>> + * @waiter: The completion to finish with an error if the operation 
>> is not a drain.
>>    *
>>    * Return: true if the specified operation is a drain.
>>    */
>> @@ -313,11 +320,12 @@ static bool __must_check 
>> assert_vdo_drain_operation(const struct admin_state_cod
>>     /**
>>    * vdo_start_draining() - Initiate a drain operation if the current 
>> state permits it.
>> - * @operation The type of drain to initiate.
>> - * @waiter The completion to notify when the drain is complete.
>> - * @initiator The vdo_admin_initiator_fn to call if the operation 
>> may begin; may be NULL.
>> + * @state: The admin_state object representing the current 
>> administrative state.
>> + * @operation: The type of drain to initiate.
>> + * @waiter: The completion to notify when the drain is complete.
>> + * @initiator: The vdo_admin_initiator_fn to call if the operation 
>> may begin; may be NULL.
>>    *
>> - * Return: true if the drain was initiated, if not the waiter will 
>> be notified.
>> + * Return: true if the drain was initiated; otherwise false, with 
>> the waiter notified.
>>    */
>>   bool vdo_start_draining(struct admin_state *state,
>>               const struct admin_state_code *operation,
>> @@ -345,6 +353,7 @@ bool vdo_start_draining(struct admin_state *state,
>>     /**
>>    * vdo_finish_draining() - Finish a drain operation if one was in 
>> progress.
>> + * @state: The admin_state object representing the current 
>> administrative state.
>>    *
>>    * Return: true if the state was draining; will notify the waiter 
>> if so.
>>    */
>> @@ -355,6 +364,8 @@ bool vdo_finish_draining(struct admin_state *state)
>>     /**
>>    * vdo_finish_draining_with_result() - Finish a drain operation 
>> with a status code.
>> + * @state: The admin_state object representing the current 
>> administrative state.
>> + * @result: The result code to return to the waiting completion.
>>    *
>>    * Return: true if the state was draining; will notify the waiter 
>> if so.
>>    */
>> @@ -365,7 +376,8 @@ bool vdo_finish_draining_with_result(struct 
>> admin_state *state, int result)
>>     /**
>>    * vdo_assert_load_operation() - Check that an operation is a load.
>> - * @waiter The completion to finish with an error if the operation 
>> is not a load.
>> + * @operation: The admin_state_code describing the operation to 
>> validate.
>> + * @waiter: The completion to finish with an error if the operation 
>> is not a load.
>>    *
>>    * Return: true if the specified operation is a load.
>>    */
>> @@ -377,9 +389,10 @@ bool vdo_assert_load_operation(const struct 
>> admin_state_code *operation,
>>     /**
>>    * vdo_start_loading() - Initiate a load operation if the current 
>> state permits it.
>> - * @operation The type of load to initiate.
>> - * @waiter The completion to notify when the load is complete (may 
>> be NULL).
>> - * @initiator The vdo_admin_initiator_fn to call if the operation 
>> may begin; may be NULL.
>> + * @state: The admin_state object representing the current 
>> administrative state.
>> + * @operation: The type of load to initiate.
>> + * @waiter: The completion to notify when the load is complete (may 
>> be NULL).
>> + * @initiator: The vdo_admin_initiator_fn to call if the operation 
>> may begin; may be NULL.
>>    *
>>    * Return: true if the load was initiated, if not the waiter will 
>> be notified.
>>    */
>> @@ -393,6 +406,7 @@ bool vdo_start_loading(struct admin_state *state,
>>     /**
>>    * vdo_finish_loading() - Finish a load operation if one was in 
>> progress.
>> + * @state: The admin_state object representing the current 
>> administrative state.
>>    *
>>    * Return: true if the state was loading; will notify the waiter if 
>> so.
>>    */
>> @@ -403,7 +417,8 @@ bool vdo_finish_loading(struct admin_state *state)
>>     /**
>>    * vdo_finish_loading_with_result() - Finish a load operation with 
>> a status code.
>> - * @result The result of the load operation.
>> + * @state: The admin_state object representing the current 
>> administrative state.
>> + * @result: The result of the load operation.
>>    *
>>    * Return: true if the state was loading; will notify the waiter if 
>> so.
>>    */
>> @@ -414,7 +429,8 @@ bool vdo_finish_loading_with_result(struct 
>> admin_state *state, int result)
>>     /**
>>    * assert_vdo_resume_operation() - Check whether an 
>> admin_state_code is a resume operation.
>> - * @waiter The completion to notify if the operation is not a resume 
>> operation; may be NULL.
>> + * @operation: The admin_state_code to check.
>> + * @waiter: The completion to notify if the operation is not a 
>> resume operation; may be NULL.
>>    *
>>    * Return: true if the code is a resume operation.
>>    */
>> @@ -427,9 +443,10 @@ static bool __must_check 
>> assert_vdo_resume_operation(const struct admin_state_co
>>     /**
>>    * vdo_start_resuming() - Initiate a resume operation if the 
>> current state permits it.
>> - * @operation The type of resume to start.
>> - * @waiter The completion to notify when the resume is complete (may 
>> be NULL).
>> - * @initiator The vdo_admin_initiator_fn to call if the operation 
>> may begin; may be NULL.
>> + * @state: The admin_state object representing the current 
>> administrative state.
>> + * @operation: The type of resume to start.
>> + * @waiter: The completion to notify when the resume is complete 
>> (may be NULL).
>> + * @initiator: The vdo_admin_initiator_fn to call if the operation 
>> may begin; may be NULL.
>>    *
>>    * Return: true if the resume was initiated, if not the waiter will 
>> be notified.
>>    */
>> @@ -443,6 +460,7 @@ bool vdo_start_resuming(struct admin_state *state,
>>     /**
>>    * vdo_finish_resuming() - Finish a resume operation if one was in 
>> progress.
>> + * @state: The admin state object representing the current 
>> administrative state.
>>    *
>>    * Return: true if the state was resuming; will notify the waiter 
>> if so.
>>    */
>> @@ -453,7 +471,8 @@ bool vdo_finish_resuming(struct admin_state *state)
>>     /**
>>    * vdo_finish_resuming_with_result() - Finish a resume operation 
>> with a status code.
>> - * @result The result of the resume operation.
>> + * @state: The admin_state object representing the current 
>> administrative state.
>> + * @result: The result of the resume operation.
>>    *
>>    * Return: true if the state was resuming; will notify the waiter 
>> if so.
>>    */
>> @@ -464,6 +483,7 @@ bool vdo_finish_resuming_with_result(struct 
>> admin_state *state, int result)
>>     /**
>>    * vdo_resume_if_quiescent() - Change the state to normal operation 
>> if the current state is
>> + * @state: The admins_state object representing the current 
>> administrative state.
>>    *                             quiescent.
>>    *
>>    * Return: VDO_SUCCESS if the state resumed, 
>> VDO_INVALID_ADMIN_STATE otherwise.
>> @@ -479,6 +499,8 @@ int vdo_resume_if_quiescent(struct admin_state 
>> *state)
>>     /**
>>    * vdo_start_operation() - Attempt to start an operation.
>> + * @state: The admin_state object representing the current 
>> administrative state.
>> + * @operation: The administrative state code representing the 
>> operation to start.
>>    *
>>    * Return: VDO_SUCCESS if the operation was started, 
>> VDO_INVALID_ADMIN_STATE if not
>>    */
>> @@ -490,8 +512,10 @@ int vdo_start_operation(struct admin_state *state,
>>     /**
>>    * vdo_start_operation_with_waiter() - Attempt to start an operation.
>> - * @waiter the completion to notify when the operation completes or 
>> fails to start; may be NULL.
>> - * @initiator The vdo_admin_initiator_fn to call if the operation 
>> may begin; may be NULL.
>> + * @state: The admin_state object representing the current 
>> administrative state.
>> + * @operation: The administrative state code representing the 
>> operation to start.
>> + * @waiter: the completion to notify when the operation completes or 
>> fails to start; may be NULL.
>> + * @initiator: The vdo_admin_initiator_fn to call if the operation 
>> may begin; may be NULL.
>>    *
>>    * Return: VDO_SUCCESS if the operation was started, 
>> VDO_INVALID_ADMIN_STATE if not
>>    */
>

