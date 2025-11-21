Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5294F21D58B
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 02:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763692313; cv=none; b=bHAYC9oIxA7Wt8C/aSntTn2eT6pqzhH47lkopBozUxZtSVaJ4CsOYibS5afh3L4PSb2Np3xvUdRkF2xFt8vcsr9u0NkUAT5AGFe3nmqUVo8PXLtSbL8X6FB3vETaoZ4YBDL1dV4M3J7ormrIAMUDw2Qv08LRom5sO1jGJMmVi38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763692313; c=relaxed/simple;
	bh=AxswPmpBzsT2X69rWVUuE2I07axLN89u09Vpy7FWzPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nkm07tZO6JWYUZPDvTQcIgrDvjU+M0JxoqEvVfPE6CIRtcf0/Ob7QyZOTn+Lhc6hLaTZ5aP1D4zKP1DlzGgtC6a4CokAa35QfTNNtJ8fyPHUQRgPeTTi98FAZ7W3utQKjZOPZwSPsi30C9lA9s2WEGrckLyveGVtrJaIX/9knsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iPZobjiF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iPZobjiF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763692310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WJ3/WUYYDqq7gq0JY9LqEKinZAiRMOLCs8+qkLi/IW0=;
	b=iPZobjiFMCXIflDjph4+EiaGYdk53OGKt89rnNBSZzmGL8vxxGTZap64SAryKUeZcycMDK
	qQR00eLi7s4cY9UKX05hHiei7y8UKBiMr8NhFMukcDyXgRHXY4sDA52LTvZC77/q0pNHlM
	4YlNllBLGjsnbNgRu2s+gdMyfoRX5os=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-zAEnPVhnMz6RIlijZ_fXmQ-1; Thu, 20 Nov 2025 21:31:48 -0500
X-MC-Unique: zAEnPVhnMz6RIlijZ_fXmQ-1
X-Mimecast-MFC-AGG-ID: zAEnPVhnMz6RIlijZ_fXmQ_1763692308
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-88044215975so64607166d6.1
        for <dm-devel@lists.linux.dev>; Thu, 20 Nov 2025 18:31:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763692308; x=1764297108;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WJ3/WUYYDqq7gq0JY9LqEKinZAiRMOLCs8+qkLi/IW0=;
        b=U8c2CH/xoRTTEGZXfeejwUetuuf0/eNUxrHFHh6LLTfKYjecsgIj5UnAuwyuXoF1bl
         /8FSaMYG2WnCn1GLYHWKeocJwaRslFI4kfgn0nZoX7h9RZLwx0QxaCo5anvmqYf0S/4g
         52lbspaBAa+aOpxCBbbrdgYwjCIxcP1gRMYM/r/QQL/W8IQYTHVEPRYCioprZJ/h0bjV
         oVamWWIhLvpn+DGwBaXbXpo/km92Sb3nevoRhCA4spVwRyJxJlpVax1KlByRdtZgatVo
         bFP2heBvHDr9VSiUCF/gP4wShhRPV6zTXNGIPfvXKIRANK1w5QQ1Jlk9bGURTpHzr8ya
         EWsw==
X-Gm-Message-State: AOJu0YzneynpVmUcrZYd4IbFwzoWe2Y50UKW1BtcquD/LgM/2qu+DkpS
	4XJXYdNQH5kPCnOcGPX4vWCezAlWDs5y1qBteJfVDazv+3k9H3Wg8x95/niobVAcJ10D1FoBTJx
	XR2zEYfcOtjWIq/ZBfc2MZqoRbdkAuD5zFNdplgu/bANjpCk61xm8aH1TRm5R
X-Gm-Gg: ASbGncs9p+HnVRpM7DJdzx4m5mnwjQ06b49C8ySwpmXQ0ARYy6But1iyt8VM5V+NhIJ
	reRdQr+abSo9Tl6WbgRMdcgn/lem4p+CYDkOX+aN7Wt62DvdOX8s9MDAAxiDqPMWoq424q37r0S
	uYonhveeTPTMCLAQxr5WxfEIcCJBAK0BXfw3Z8NgP3LCmHIdr5rQHUKENfy/ctVqSA9jy3DbkEF
	a69IUsZ684bG7os4ti8h0yJOsLxR2JWJLIo4RRGP2TePFOjNb6xKYLnEj/zjyTCPJhXaezbEIxR
	6CVxZLqlSTT3i7y+DsYkqhuuapN9qgAwvi7t1czLBolxud6SztTiNwL8hySqC0tVEqEovJR3hoz
	zUh+8VwErp+P852OoMry87PQWNDkdkX4Pwq0gf689XgRWmeXm5ZVH5KtBLg==
X-Received: by 2002:a05:6214:e69:b0:880:541c:822c with SMTP id 6a1803df08f44-8847c4990a0mr11750336d6.8.1763692308346;
        Thu, 20 Nov 2025 18:31:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFi4INyHD2MLih4zyl8m66b89987R76f8WKslh9+/uD4HYcoWiQdIBOHFpTbw7z23aff8B9jw==
X-Received: by 2002:a05:6214:e69:b0:880:541c:822c with SMTP id 6a1803df08f44-8847c4990a0mr11750126d6.8.1763692307886;
        Thu, 20 Nov 2025 18:31:47 -0800 (PST)
Received: from ?IPV6:2600:4040:5308:eb00:a77e:fec5:d269:f23e? ([2600:4040:5308:eb00:a77e:fec5:d269:f23e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e469825sm29607606d6.15.2025.11.20.18.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 18:31:47 -0800 (PST)
Message-ID: <f384ab6d-ddab-493c-aa52-71d01addad9f@redhat.com>
Date: Thu, 20 Nov 2025 21:31:46 -0500
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: vdo: fix kernel-doc warnings in admin-state.c
To: Sunday Adelodun <adelodunolaoluwa@yahoo.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
 linux-kernel-mentees@lists.linuxfoundation.org
References: <20251120164734.7187-1-adelodunolaoluwa.ref@yahoo.com>
 <20251120164734.7187-1-adelodunolaoluwa@yahoo.com>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <20251120164734.7187-1-adelodunolaoluwa@yahoo.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yGuYM6109atqC7YfH3wZFYda3Ab_Xn5sKL6PsaICvrg_1763692308
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/25 11:47 AM, Sunday Adelodun wrote:
> Several functions in admin-state.c were missing parameter descriptions
> leading to multiple kernel-doc warnings during build.
> 
> Update the affected comments by adding missing @state, @operation,
> @waiter, @initiator, @result, and other parameter descriptions.
> 
> No functional changes.

I'm ambivalent about some of the new comments. But there are also a lot 
more kerneldoc warnings in the dm-vdo target, and now that you've 
pointed them out I think I'll try to fix them all up myself. It may take 
me a day or two to get the patch out.

Thanks for bringing this up.
Matt

> Signed-off-by: Sunday Adelodun <adelodunolaoluwa@yahoo.com>
> ---
>   drivers/md/dm-vdo/admin-state.c | 74 ++++++++++++++++++++++-----------
>   1 file changed, 49 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/md/dm-vdo/admin-state.c b/drivers/md/dm-vdo/admin-state.c
> index 3f9dba525154..eedbe080f632 100644
> --- a/drivers/md/dm-vdo/admin-state.c
> +++ b/drivers/md/dm-vdo/admin-state.c
> @@ -187,6 +187,8 @@ static const struct admin_state_code *get_next_state(const struct admin_state *s
>   
>   /**
>    * vdo_finish_operation() - Finish the current operation.
> + * @state: The admin_state object representing the current operation.
> + * @result: The result code to pass to any waiting completion handler.
>    *
>    * Will notify the operation waiter if there is one. This method should be used for operations
>    * started with vdo_start_operation(). For operations which were started with vdo_start_draining(),
> @@ -214,8 +216,10 @@ bool vdo_finish_operation(struct admin_state *state, int result)
>   
>   /**
>    * begin_operation() - Begin an operation if it may be started given the current state.
> - * @waiter A completion to notify when the operation is complete; may be NULL.
> - * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
> + * @state: The admin_state object representing the current administrative state.
> + * @operation: The state code describing the operation to begin.
> + * @waiter: A completion to notify when the operation is complete; may be NULL.
> + * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
>    *
>    * Return: VDO_SUCCESS or an error.
>    */
> @@ -259,8 +263,10 @@ static int __must_check begin_operation(struct admin_state *state,
>   
>   /**
>    * start_operation() - Start an operation if it may be started given the current state.
> - * @waiter     A completion to notify when the operation is complete.
> - * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
> + * @state: The admin_state object representing the current administrative state.
> + * @operation: The state code describing the operation to begin.
> + * @waiter:     A completion to notify when the operation is complete.
> + * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
>    *
>    * Return: true if the operation was started.
>    */
> @@ -274,10 +280,10 @@ static inline bool __must_check start_operation(struct admin_state *state,
>   
>   /**
>    * check_code() - Check the result of a state validation.
> - * @valid true if the code is of an appropriate type.
> - * @code The code which failed to be of the correct type.
> - * @what What the code failed to be, for logging.
> - * @waiter The completion to notify of the error; may be NULL.
> + * @valid: true if the code is of an appropriate type.
> + * @code: The code which failed to be of the correct type.
> + * @what: What the code failed to be, for logging.
> + * @waiter: The completion to notify of the error; may be NULL.
>    *
>    * If the result failed, log an invalid state error and, if there is a waiter, notify it.
>    *
> @@ -301,7 +307,8 @@ static bool check_code(bool valid, const struct admin_state_code *code, const ch
>   
>   /**
>    * assert_vdo_drain_operation() - Check that an operation is a drain.
> - * @waiter The completion to finish with an error if the operation is not a drain.
> + * @operation: The drain operation type to check.
> + * @waiter: The completion to finish with an error if the operation is not a drain.
>    *
>    * Return: true if the specified operation is a drain.
>    */
> @@ -313,11 +320,12 @@ static bool __must_check assert_vdo_drain_operation(const struct admin_state_cod
>   
>   /**
>    * vdo_start_draining() - Initiate a drain operation if the current state permits it.
> - * @operation The type of drain to initiate.
> - * @waiter The completion to notify when the drain is complete.
> - * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
> + * @state: The admin_state object representing the current administrative state.
> + * @operation: The type of drain to initiate.
> + * @waiter: The completion to notify when the drain is complete.
> + * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
>    *
> - * Return: true if the drain was initiated, if not the waiter will be notified.
> + * Return: true if the drain was initiated; otherwise false, with the waiter notified.
>    */
>   bool vdo_start_draining(struct admin_state *state,
>   			const struct admin_state_code *operation,
> @@ -345,6 +353,7 @@ bool vdo_start_draining(struct admin_state *state,
>   
>   /**
>    * vdo_finish_draining() - Finish a drain operation if one was in progress.
> + * @state: The admin_state object representing the current administrative state.
>    *
>    * Return: true if the state was draining; will notify the waiter if so.
>    */
> @@ -355,6 +364,8 @@ bool vdo_finish_draining(struct admin_state *state)
>   
>   /**
>    * vdo_finish_draining_with_result() - Finish a drain operation with a status code.
> + * @state: The admin_state object representing the current administrative state.
> + * @result: The result code to return to the waiting completion.
>    *
>    * Return: true if the state was draining; will notify the waiter if so.
>    */
> @@ -365,7 +376,8 @@ bool vdo_finish_draining_with_result(struct admin_state *state, int result)
>   
>   /**
>    * vdo_assert_load_operation() - Check that an operation is a load.
> - * @waiter The completion to finish with an error if the operation is not a load.
> + * @operation: The admin_state_code describing the operation to validate.
> + * @waiter: The completion to finish with an error if the operation is not a load.
>    *
>    * Return: true if the specified operation is a load.
>    */
> @@ -377,9 +389,10 @@ bool vdo_assert_load_operation(const struct admin_state_code *operation,
>   
>   /**
>    * vdo_start_loading() - Initiate a load operation if the current state permits it.
> - * @operation The type of load to initiate.
> - * @waiter The completion to notify when the load is complete (may be NULL).
> - * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
> + * @state: The admin_state object representing the current administrative state.
> + * @operation: The type of load to initiate.
> + * @waiter: The completion to notify when the load is complete (may be NULL).
> + * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
>    *
>    * Return: true if the load was initiated, if not the waiter will be notified.
>    */
> @@ -393,6 +406,7 @@ bool vdo_start_loading(struct admin_state *state,
>   
>   /**
>    * vdo_finish_loading() - Finish a load operation if one was in progress.
> + * @state: The admin_state object representing the current administrative state.
>    *
>    * Return: true if the state was loading; will notify the waiter if so.
>    */
> @@ -403,7 +417,8 @@ bool vdo_finish_loading(struct admin_state *state)
>   
>   /**
>    * vdo_finish_loading_with_result() - Finish a load operation with a status code.
> - * @result The result of the load operation.
> + * @state: The admin_state object representing the current administrative state.
> + * @result: The result of the load operation.
>    *
>    * Return: true if the state was loading; will notify the waiter if so.
>    */
> @@ -414,7 +429,8 @@ bool vdo_finish_loading_with_result(struct admin_state *state, int result)
>   
>   /**
>    * assert_vdo_resume_operation() - Check whether an admin_state_code is a resume operation.
> - * @waiter The completion to notify if the operation is not a resume operation; may be NULL.
> + * @operation: The admin_state_code to check.
> + * @waiter: The completion to notify if the operation is not a resume operation; may be NULL.
>    *
>    * Return: true if the code is a resume operation.
>    */
> @@ -427,9 +443,10 @@ static bool __must_check assert_vdo_resume_operation(const struct admin_state_co
>   
>   /**
>    * vdo_start_resuming() - Initiate a resume operation if the current state permits it.
> - * @operation The type of resume to start.
> - * @waiter The completion to notify when the resume is complete (may be NULL).
> - * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
> + * @state: The admin_state object representing the current administrative state.
> + * @operation: The type of resume to start.
> + * @waiter: The completion to notify when the resume is complete (may be NULL).
> + * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
>    *
>    * Return: true if the resume was initiated, if not the waiter will be notified.
>    */
> @@ -443,6 +460,7 @@ bool vdo_start_resuming(struct admin_state *state,
>   
>   /**
>    * vdo_finish_resuming() - Finish a resume operation if one was in progress.
> + * @state: The admin state object representing the current administrative state.
>    *
>    * Return: true if the state was resuming; will notify the waiter if so.
>    */
> @@ -453,7 +471,8 @@ bool vdo_finish_resuming(struct admin_state *state)
>   
>   /**
>    * vdo_finish_resuming_with_result() - Finish a resume operation with a status code.
> - * @result The result of the resume operation.
> + * @state: The admin_state object representing the current administrative state.
> + * @result: The result of the resume operation.
>    *
>    * Return: true if the state was resuming; will notify the waiter if so.
>    */
> @@ -464,6 +483,7 @@ bool vdo_finish_resuming_with_result(struct admin_state *state, int result)
>   
>   /**
>    * vdo_resume_if_quiescent() - Change the state to normal operation if the current state is
> + * @state: The admins_state object representing the current administrative state.
>    *                             quiescent.
>    *
>    * Return: VDO_SUCCESS if the state resumed, VDO_INVALID_ADMIN_STATE otherwise.
> @@ -479,6 +499,8 @@ int vdo_resume_if_quiescent(struct admin_state *state)
>   
>   /**
>    * vdo_start_operation() - Attempt to start an operation.
> + * @state: The admin_state object representing the current administrative state.
> + * @operation: The administrative state code representing the operation to start.
>    *
>    * Return: VDO_SUCCESS if the operation was started, VDO_INVALID_ADMIN_STATE if not
>    */
> @@ -490,8 +512,10 @@ int vdo_start_operation(struct admin_state *state,
>   
>   /**
>    * vdo_start_operation_with_waiter() - Attempt to start an operation.
> - * @waiter the completion to notify when the operation completes or fails to start; may be NULL.
> - * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
> + * @state: The admin_state object representing the current administrative state.
> + * @operation: The administrative state code representing the operation to start.
> + * @waiter: the completion to notify when the operation completes or fails to start; may be NULL.
> + * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
>    *
>    * Return: VDO_SUCCESS if the operation was started, VDO_INVALID_ADMIN_STATE if not
>    */

