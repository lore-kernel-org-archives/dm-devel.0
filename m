Received: from sonic306-20.consmr.mail.gq1.yahoo.com (sonic306-20.consmr.mail.gq1.yahoo.com [98.137.68.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB2F266EFC
	for <dm-devel@lists.linux.dev>; Thu, 20 Nov 2025 16:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=98.137.68.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763657274; cv=none; b=l+YYSVGQDrCKxgCdbks9H0fwDkMPg2sZ5J0MdsHb/smyvGIsBxiqLYF8PVyrI741FYfffi5qTge+262WcQuWGM5S+UOYToOlpE3nGnMOGHsF/lwhvYX9bMYjWs8LE1SzJCpKVtIICEgMLlWuJCh26Jp4igS70/u3adVKIw8obh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763657274; c=relaxed/simple;
	bh=y/c9xtISe++QnxDp2QnrHRVW8SYpxeGoIr6rLVQ0UpA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:References; b=jcYO+y22v9arEdNqQr438IYFsDW/7dEhZM90DSWw9m//cgH5a4FkjRyO1p/zsAfiX3jEMa3yFNhKefwd52Uwilh9eNlQKumVUeUjr61XKgwRo60hnWur7DR0hML/6F5IGBhlwZCABVyLDHCZP+YnkHRTPI9T0S9pqSad8LiCr3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=Xhorz4NX; arc=none smtp.client-ip=98.137.68.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="Xhorz4NX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1763657265; bh=dEkx6XKbdWjDU5m39xhQKdY8ejLQw8IOPYo/NU14WtQ=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=Xhorz4NXKVXCEbWA7iKT2g0GDtnYPSaboLPnn0bU+uEf0SIH+NHdxRqXIaZm3WJysw9AwWxlSwbZgq5+J1G9Wo6ALXf8dMbz6HVSn9m+IMlB60EhQC8+Z0bwjp6A1IZQPJPVe9U7FAQbsMWyx06ZDgR4W7AegLst+z+0bZsFB9FloUK8Y+jQR5nFRWcRAjavr9vDfYrqNYgs8jcapTGkeb6GG22VysCu2JPweGXJEZto2fHDLFeSHLVWMT+3fnuGp6DnVGAkqVjQvhhMAHkT6lyKuQycuIzAu3mrF5LRy6JW3ej+NJ9NXXi/Xv6R6SGB22sowQ2K76MeW4TtHNf+qQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1763657265; bh=3hSVWLqQz/3lrlG8qUYTaK2Fnv/EnGLS2oPdzXV/vh3=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=rdv0rmGnRf5ti/PRas5iSv6nwCiyr7jzSHb8+G/13TlL2Notaa6EBOvVCEccEOHvQ+uxofZqzhA98BG+NL4wAdEBvzN1o0V95qj4G5ewEut0cw5YIWFHxEU+VRcd6Ebf4zXrMyeYa493hnXUR8gmqYX0MkxvJ8YPmz5NPcm5PWX2wxK9cGBrT4OxXOZWQwhw1KJpTRGLdE9C26R2M1kLh0qCw2M+bUbsDgY6jEWcxXA7mpHy30fxR6UGYA9PQOJo6bQu96bpgX0i8cLmj9gz4uPwUj3v8qFWEIbeBKqJd8mA5ULbZbATdjlpiJMRo01QDtal9z1maCOL249BlXr/BQ==
X-YMail-OSG: BXwPrhcVM1nLT3XGU0koj8hGwi6nyFzIC9b1GlK9QLjFnYYWFtj6VyH6M2fGc6z
 HU1btkhbBpZzGNDUc55tD7CDLI8o0q3i8.WpDtHvt2vBT3D1ezSQ8g12SeYy6531OmNVQ8HhCv76
 .B6hvtrzTTjmLqziYgY618kUFyH.Gf_5Xc46o.wAslGYvCvGQQRYktxpCw8Se6G7r7dJLZXA02bf
 JE1o8GPXktqLGOkvEfo_U7wc87bCfb8skfSls1D6YXA2ZCyskjrEpE.3ck2rGyWyzFzUH8b6xGPX
 8xLBMf6uQufboJaivnyU__.Igo9a_9Y05axWdCCIy5GZKGfLrni4VTE8mk.Jo9eAKIZnQCw4T6Jo
 jS0EvFLf26w6RDPv5KAAz4UzhqRnSctw33dfk3fx5MIhX1KalzKpcNZfLLLtlid3aEkSPxTguXvk
 TdD2LWYKoghQB1c6OXkhblmhYDBx2O9Xv1RCyMkuKZd5OANkZcXdRJVZkR.TMGJVYV7PQWtdarlD
 nij4Lo3QyugaHEKqDTNKrij5WBgZLkvWiiV_1nCVX457Dx04lG.RKoFaNqckEyzadQN4nS2Oxi9N
 UkOyvvzlIlSozFlV7jALznzat.mC_RR10qP5j7B4vb6XFRQI6QmK2pJwd6MbEmk6gpNa7w0W1pnv
 TbCNS1FQcOEp0XKmXON9.LEGRmODYfJreAR3WA8AQhfBqVHZPO4gIUSDON_aQUcY1AkyAVTZIOqx
 SA0kVhNoNEeMlBQ.QzZDU2EjZDHvvFvKR6BLHhTM5H_ZahwUncr3gn6sYRp742mZTwJuk_Xzm8Al
 vl7ED7L6XAoosPP1R6XbnKhJ6s83jWzWwT0kPCH3UBcXoCrApckCpjciLQHAAlpoWo1T6NEYkAOd
 XDExhfP_nYpYomYVmzdoEan1PJgHOcVqBG10IEfMI11m6mQd2NYIcAW9YFK3FoERRNAo6Jp60VRx
 NE7KA1.IX.Br666_5EYLo2WI5lsRzxEYvok8br6uHCqssLwTWiiZs5.ZLWSe8hwI171YnlY79vpO
 CPqAP9vKe._THteG8JqCguAj9G36DXfQzhnI7PCb5qK_2ijbr87T.k23RAzHvOXh3UWW3a3eVCrO
 DT11WCFmvHKfPio1r_UcLpa9_qcj0O7F_1kw5CCr1GLqAsTJH9pOTF8oLi8XGEB0WUjAEJ3hCF.X
 s8.2HvRqoz5GO6uFoJCzjjUoSnNdOWAIHmBuxpwSAYvHPhkqA_fP4wyt.WbK2rCQTrj9CHdM4x5C
 YCj8KANJQmesyb7q_Ugmc1h4mVyddLtpnna072tL8XegpPBWH91lfRSGYSNzBO_Tzl_b_.NEpyBP
 DZVoGTn2QJp8hCFOf0wSsxoaisd5Ius.a3DHGRiNz2Aaf6RvaZOpaiDH1KPZJmDMb8Qs39kGwu18
 PCySA1J8rWefK9HAyOgAJQHfTvg.HQ69RjqUDxtsE5fEvdpKqCCCX3cjCfqPOY7tP8r0yEx3E2l7
 GuLTJUF.VQrLt4F6BeoejRoLHGsOvX7SXFVqFNzEqWWMPgVwxIBydNrBnXRgM08vE4.FrdHGgaPa
 kdEjgEfYB5cIkHSOMGF7Y1x.qd6cF66EDfnToyXHivcDSuYyxfZiY5E3_geyt5w0XTB_uPoYCwz3
 RI58dFUOkqAFSJjamJr5j9V6gUb4wubD58pUdMM6BvrRDJHB5kU3q5kDhOcjHv1xwMrMwxnu3gRs
 kW3qIT_BxmOy1N7xp0jqm5aCftAYndDahJDCkRQf_0HRiJWQ4vn8VRKdsHBzqdR6zKEkpn49hlwQ
 aLc7k4JjS9BGw67p4OplEJUZ01VVl.vGhX6ZEtNTP0qjc.Vb771AohIaElanrAPHYMBWmgfIdxbU
 u1FPhkK05HAtOYN8p8MQ4U1GC.wl_ftwfJ82W9UpAn4_w5HMLMV_UDkXtW19CbBdoF0mlC3vDTpY
 Wcea.ct8N_VcMozZbCQly3yiSvQ4aQlJhLb1b06Gm5opBF7VxCOvbFYgEhRhceCRCtiYMFrJaZwP
 B8cZYIS0JK8cP_rDpVB_d.cS7dYZYvv4pUSsEqSSmu8ujmCdy7TfZc9qBm.T6kQ_ZtmwVMRKFaj8
 mSE97dHFGjj_FSMU0ANU6..3kneMpjKSSdM_f._znoNKXMtU7i6ILv57LtZbl5LAtucGbIqpsvls
 OcxoAItEMLUWsvJMBaZ_M9GolsKhFJi28zVLivXiPsqz1xpmY8VhMG2tPeawPM7LXGiyhwA3A0uu
 NbRkwg2JNmD.fQBELNVjTjGFHp4qh972Gpl_ib9O7y3upzNe12iNpmyp5WckmvDykBuEBJwQ7o7U
 msA--
X-Sonic-MF: <adelodunolaoluwa@yahoo.com>
X-Sonic-ID: 0f96322e-7358-4416-9f75-deeeddb72554
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.gq1.yahoo.com with HTTP; Thu, 20 Nov 2025 16:47:45 +0000
Received: by hermes--production-bf1-9c4b8bbbf-n9sn2 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 2cd85203a8b486bf580af99601b670f4;
          Thu, 20 Nov 2025 16:47:41 +0000 (UTC)
From: Sunday Adelodun <adelodunolaoluwa@yahoo.com>
To: msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	linux-kernel-mentees@lists.linuxfoundation.org,
	Sunday Adelodun <adelodunolaoluwa@yahoo.com>
Subject: [PATCH] dm: vdo: fix kernel-doc warnings in admin-state.c
Date: Thu, 20 Nov 2025 17:47:34 +0100
Message-ID: <20251120164734.7187-1-adelodunolaoluwa@yahoo.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20251120164734.7187-1-adelodunolaoluwa.ref@yahoo.com>

Several functions in admin-state.c were missing parameter descriptions
leading to multiple kernel-doc warnings during build.

Update the affected comments by adding missing @state, @operation,
@waiter, @initiator, @result, and other parameter descriptions.

No functional changes.

Signed-off-by: Sunday Adelodun <adelodunolaoluwa@yahoo.com>
---
 drivers/md/dm-vdo/admin-state.c | 74 ++++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-vdo/admin-state.c b/drivers/md/dm-vdo/admin-state.c
index 3f9dba525154..eedbe080f632 100644
--- a/drivers/md/dm-vdo/admin-state.c
+++ b/drivers/md/dm-vdo/admin-state.c
@@ -187,6 +187,8 @@ static const struct admin_state_code *get_next_state(const struct admin_state *s
 
 /**
  * vdo_finish_operation() - Finish the current operation.
+ * @state: The admin_state object representing the current operation.
+ * @result: The result code to pass to any waiting completion handler.
  *
  * Will notify the operation waiter if there is one. This method should be used for operations
  * started with vdo_start_operation(). For operations which were started with vdo_start_draining(),
@@ -214,8 +216,10 @@ bool vdo_finish_operation(struct admin_state *state, int result)
 
 /**
  * begin_operation() - Begin an operation if it may be started given the current state.
- * @waiter A completion to notify when the operation is complete; may be NULL.
- * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
+ * @state: The admin_state object representing the current administrative state.
+ * @operation: The state code describing the operation to begin.
+ * @waiter: A completion to notify when the operation is complete; may be NULL.
+ * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
  *
  * Return: VDO_SUCCESS or an error.
  */
@@ -259,8 +263,10 @@ static int __must_check begin_operation(struct admin_state *state,
 
 /**
  * start_operation() - Start an operation if it may be started given the current state.
- * @waiter     A completion to notify when the operation is complete.
- * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
+ * @state: The admin_state object representing the current administrative state.
+ * @operation: The state code describing the operation to begin.
+ * @waiter:     A completion to notify when the operation is complete.
+ * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
  *
  * Return: true if the operation was started.
  */
@@ -274,10 +280,10 @@ static inline bool __must_check start_operation(struct admin_state *state,
 
 /**
  * check_code() - Check the result of a state validation.
- * @valid true if the code is of an appropriate type.
- * @code The code which failed to be of the correct type.
- * @what What the code failed to be, for logging.
- * @waiter The completion to notify of the error; may be NULL.
+ * @valid: true if the code is of an appropriate type.
+ * @code: The code which failed to be of the correct type.
+ * @what: What the code failed to be, for logging.
+ * @waiter: The completion to notify of the error; may be NULL.
  *
  * If the result failed, log an invalid state error and, if there is a waiter, notify it.
  *
@@ -301,7 +307,8 @@ static bool check_code(bool valid, const struct admin_state_code *code, const ch
 
 /**
  * assert_vdo_drain_operation() - Check that an operation is a drain.
- * @waiter The completion to finish with an error if the operation is not a drain.
+ * @operation: The drain operation type to check.
+ * @waiter: The completion to finish with an error if the operation is not a drain.
  *
  * Return: true if the specified operation is a drain.
  */
@@ -313,11 +320,12 @@ static bool __must_check assert_vdo_drain_operation(const struct admin_state_cod
 
 /**
  * vdo_start_draining() - Initiate a drain operation if the current state permits it.
- * @operation The type of drain to initiate.
- * @waiter The completion to notify when the drain is complete.
- * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
+ * @state: The admin_state object representing the current administrative state.
+ * @operation: The type of drain to initiate.
+ * @waiter: The completion to notify when the drain is complete.
+ * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
  *
- * Return: true if the drain was initiated, if not the waiter will be notified.
+ * Return: true if the drain was initiated; otherwise false, with the waiter notified.
  */
 bool vdo_start_draining(struct admin_state *state,
 			const struct admin_state_code *operation,
@@ -345,6 +353,7 @@ bool vdo_start_draining(struct admin_state *state,
 
 /**
  * vdo_finish_draining() - Finish a drain operation if one was in progress.
+ * @state: The admin_state object representing the current administrative state.
  *
  * Return: true if the state was draining; will notify the waiter if so.
  */
@@ -355,6 +364,8 @@ bool vdo_finish_draining(struct admin_state *state)
 
 /**
  * vdo_finish_draining_with_result() - Finish a drain operation with a status code.
+ * @state: The admin_state object representing the current administrative state.
+ * @result: The result code to return to the waiting completion.
  *
  * Return: true if the state was draining; will notify the waiter if so.
  */
@@ -365,7 +376,8 @@ bool vdo_finish_draining_with_result(struct admin_state *state, int result)
 
 /**
  * vdo_assert_load_operation() - Check that an operation is a load.
- * @waiter The completion to finish with an error if the operation is not a load.
+ * @operation: The admin_state_code describing the operation to validate.
+ * @waiter: The completion to finish with an error if the operation is not a load.
  *
  * Return: true if the specified operation is a load.
  */
@@ -377,9 +389,10 @@ bool vdo_assert_load_operation(const struct admin_state_code *operation,
 
 /**
  * vdo_start_loading() - Initiate a load operation if the current state permits it.
- * @operation The type of load to initiate.
- * @waiter The completion to notify when the load is complete (may be NULL).
- * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
+ * @state: The admin_state object representing the current administrative state.
+ * @operation: The type of load to initiate.
+ * @waiter: The completion to notify when the load is complete (may be NULL).
+ * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
  *
  * Return: true if the load was initiated, if not the waiter will be notified.
  */
@@ -393,6 +406,7 @@ bool vdo_start_loading(struct admin_state *state,
 
 /**
  * vdo_finish_loading() - Finish a load operation if one was in progress.
+ * @state: The admin_state object representing the current administrative state.
  *
  * Return: true if the state was loading; will notify the waiter if so.
  */
@@ -403,7 +417,8 @@ bool vdo_finish_loading(struct admin_state *state)
 
 /**
  * vdo_finish_loading_with_result() - Finish a load operation with a status code.
- * @result The result of the load operation.
+ * @state: The admin_state object representing the current administrative state.
+ * @result: The result of the load operation.
  *
  * Return: true if the state was loading; will notify the waiter if so.
  */
@@ -414,7 +429,8 @@ bool vdo_finish_loading_with_result(struct admin_state *state, int result)
 
 /**
  * assert_vdo_resume_operation() - Check whether an admin_state_code is a resume operation.
- * @waiter The completion to notify if the operation is not a resume operation; may be NULL.
+ * @operation: The admin_state_code to check.
+ * @waiter: The completion to notify if the operation is not a resume operation; may be NULL.
  *
  * Return: true if the code is a resume operation.
  */
@@ -427,9 +443,10 @@ static bool __must_check assert_vdo_resume_operation(const struct admin_state_co
 
 /**
  * vdo_start_resuming() - Initiate a resume operation if the current state permits it.
- * @operation The type of resume to start.
- * @waiter The completion to notify when the resume is complete (may be NULL).
- * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
+ * @state: The admin_state object representing the current administrative state.
+ * @operation: The type of resume to start.
+ * @waiter: The completion to notify when the resume is complete (may be NULL).
+ * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
  *
  * Return: true if the resume was initiated, if not the waiter will be notified.
  */
@@ -443,6 +460,7 @@ bool vdo_start_resuming(struct admin_state *state,
 
 /**
  * vdo_finish_resuming() - Finish a resume operation if one was in progress.
+ * @state: The admin state object representing the current administrative state.
  *
  * Return: true if the state was resuming; will notify the waiter if so.
  */
@@ -453,7 +471,8 @@ bool vdo_finish_resuming(struct admin_state *state)
 
 /**
  * vdo_finish_resuming_with_result() - Finish a resume operation with a status code.
- * @result The result of the resume operation.
+ * @state: The admin_state object representing the current administrative state.
+ * @result: The result of the resume operation.
  *
  * Return: true if the state was resuming; will notify the waiter if so.
  */
@@ -464,6 +483,7 @@ bool vdo_finish_resuming_with_result(struct admin_state *state, int result)
 
 /**
  * vdo_resume_if_quiescent() - Change the state to normal operation if the current state is
+ * @state: The admins_state object representing the current administrative state.
  *                             quiescent.
  *
  * Return: VDO_SUCCESS if the state resumed, VDO_INVALID_ADMIN_STATE otherwise.
@@ -479,6 +499,8 @@ int vdo_resume_if_quiescent(struct admin_state *state)
 
 /**
  * vdo_start_operation() - Attempt to start an operation.
+ * @state: The admin_state object representing the current administrative state.
+ * @operation: The administrative state code representing the operation to start.
  *
  * Return: VDO_SUCCESS if the operation was started, VDO_INVALID_ADMIN_STATE if not
  */
@@ -490,8 +512,10 @@ int vdo_start_operation(struct admin_state *state,
 
 /**
  * vdo_start_operation_with_waiter() - Attempt to start an operation.
- * @waiter the completion to notify when the operation completes or fails to start; may be NULL.
- * @initiator The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
+ * @state: The admin_state object representing the current administrative state.
+ * @operation: The administrative state code representing the operation to start.
+ * @waiter: the completion to notify when the operation completes or fails to start; may be NULL.
+ * @initiator: The vdo_admin_initiator_fn to call if the operation may begin; may be NULL.
  *
  * Return: VDO_SUCCESS if the operation was started, VDO_INVALID_ADMIN_STATE if not
  */
-- 
2.43.0

