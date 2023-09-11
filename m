Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E425AEE7FF4
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450378;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NTPHg6uMh12OWU3pWGy8YZJeEFselZEIia7MWxdHhYc=;
	b=euwUqZYpOYJv91WbJGbpgKW92pKblOOsV1+5QcXJI2lyciuip4iDO/ziHh5XudOFeOBCkh
	ekrrwu6YaTY1+DMI5blLmeYrTpgL6GgtfRLBMGrjBNfeQNSr/cwXjb5sNezlBA24zwZj5c
	OmHv/dYBZ2uZbkLshnohVRbZkJeFZ8o=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-Zx4WkST0NB-wVj-6HMJ37Q-1; Mon, 11 Sep 2023 12:39:35 -0400
X-MC-Unique: Zx4WkST0NB-wVj-6HMJ37Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7D443C0E20D;
	Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BA1D310EE402;
	Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 225331946A49;
	Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F7EE19465A8
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3E37C44069; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 34E224404C
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D29E945E66
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-90-SVODEKvlPIGLC9NofFDCKQ-1; Mon,
 11 Sep 2023 12:39:23 -0400
X-MC-Unique: SVODEKvlPIGLC9NofFDCKQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 5985B21860;
 Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2527B139CC;
 Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id gH5yB7lC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:21 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:35 +0200
Message-ID: <20230911163846.27197-27-mwilck@suse.com>
In-Reply-To: <20230911163846.27197-1-mwilck@suse.com>
References: <20230911163846.27197-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v2 26/37] multipath-tools tests: add test for
 ordering of bindings
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

As the assignment of free aliases now relies on the bindings being
properly sorted, add some unit tests to make sure the sorting algorithm
works.
---
 tests/alias.c | 212 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 209 insertions(+), 3 deletions(-)

diff --git a/tests/alias.c b/tests/alias.c
index dff5f93..2e765fb 100644
--- a/tests/alias.c
+++ b/tests/alias.c
@@ -13,6 +13,9 @@
 #include "globals.c"
 #include "../libmultipath/alias.c"
 
+/* For verbose printing of all aliases in the ordering tests */
+#define ALIAS_DEBUG 0
+
 #if INT_MAX == 0x7fffffff
 /* user_friendly_name for map #INT_MAX */
 #define MPATH_ID_INT_MAX "fxshrxw"
@@ -439,11 +442,12 @@ static void mock_self_alias(const char *alias, const char *wwid)
 		expect_condlog(3, USED_STR(alias, wwid));		\
 	} while(0)
 
-static void __mock_bindings_file(const char *content)
+static void __mock_bindings_file(const char *content, bool conflict_ok)
 {
 	char *cnt __attribute__((cleanup(cleanup_charp))) = NULL;
 	char *token, *savep = NULL;
 	int i;
+	LargestIntegralType values[] = { BINDING_ADDED, BINDING_CONFLICT };
 
 	cnt = strdup(content);
 	assert_ptr_not_equal(cnt, NULL);
@@ -459,12 +463,12 @@ static void __mock_bindings_file(const char *content)
 			continue;
 
 		rc = add_binding(&global_bindings, alias, wwid);
-		assert_int_equal(rc, BINDING_ADDED);
+		assert_in_set(rc, values, conflict_ok ? 2 : 1);
 	}
 }
 
 static void mock_bindings_file(const char *content) {
-	return __mock_bindings_file(content);
+	return __mock_bindings_file(content, false);
 }
 
 static int teardown_bindings(void **state)
@@ -1744,6 +1748,207 @@ static int test_get_user_friendly_alias()
 	return cmocka_run_group_tests(tests, NULL, NULL);
 }
 
+/* Numbers 1-1000, randomly shuffled */
+static int random_numbers[1000] = {
+	694, 977, 224, 178, 841, 818, 914, 549, 831, 942, 263, 834, 919, 800,
+	111, 517, 719, 297, 988, 98, 332, 516, 754, 772, 495, 488, 331, 529,
+	142, 747, 848, 618, 375, 624, 74, 753, 782, 944, 623, 468, 862, 997,
+	417, 258, 298, 774, 673, 904, 883, 766, 867, 400, 11, 950, 14, 784,
+	655, 155, 396, 9, 743, 93, 651, 245, 968, 306, 785, 581, 880, 486,
+	168, 631, 203, 4, 663, 294, 702, 762, 619, 684, 48, 181, 21, 443, 643,
+	863, 1000, 327, 26, 126, 382, 765, 586, 76, 49, 925, 319, 865, 797,
+	876, 693, 334, 433, 243, 419, 901, 854, 326, 985, 347, 874, 527, 282,
+	290, 380, 167, 95, 3, 257, 936, 60, 426, 227, 345, 577, 492, 467, 580,
+	967, 422, 823, 718, 610, 64, 700, 412, 163, 288, 506, 828, 432, 51,
+	356, 348, 539, 478, 17, 945, 602, 123, 450, 660, 429, 113, 310, 358,
+	512, 758, 508, 19, 542, 304, 286, 446, 918, 723, 333, 603, 731, 978,
+	230, 697, 109, 872, 175, 853, 947, 965, 121, 222, 101, 811, 117, 601,
+	191, 752, 384, 415, 938, 278, 915, 715, 240, 552, 912, 838, 150, 840,
+	627, 29, 636, 464, 861, 481, 992, 249, 934, 82, 368, 724, 807, 593,
+	157, 147, 199, 637, 41, 62, 902, 505, 621, 342, 174, 260, 729, 961,
+	219, 311, 629, 789, 81, 739, 860, 712, 223, 165, 741, 981, 485, 363,
+	346, 709, 125, 369, 279, 634, 399, 162, 193, 769, 149, 314, 868, 612,
+	524, 675, 341, 343, 476, 606, 388, 613, 850, 264, 903, 451, 908, 779,
+	453, 148, 497, 46, 132, 43, 885, 955, 269, 395, 72, 128, 767, 989,
+	929, 423, 742, 55, 13, 79, 924, 182, 295, 563, 668, 169, 974, 154,
+	970, 54, 674, 52, 437, 570, 550, 531, 554, 793, 678, 218, 367, 105,
+	197, 315, 958, 892, 86, 47, 284, 37, 561, 522, 198, 689, 817, 573,
+	877, 201, 803, 501, 881, 546, 530, 523, 780, 579, 953, 135, 23, 620,
+	84, 698, 303, 656, 357, 323, 494, 58, 131, 913, 995, 120, 70, 1, 195,
+	365, 210, 25, 898, 173, 307, 239, 77, 418, 952, 963, 92, 455, 425, 12,
+	536, 161, 328, 933, 401, 251, 735, 725, 362, 322, 557, 681, 302, 53,
+	786, 801, 391, 946, 748, 133, 717, 851, 7, 372, 993, 387, 906, 373,
+	667, 33, 670, 389, 209, 611, 896, 652, 69, 999, 344, 845, 633, 36,
+	487, 192, 180, 45, 640, 427, 707, 805, 188, 152, 905, 217, 30, 252,
+	386, 665, 299, 541, 410, 787, 5, 857, 751, 392, 44, 595, 146, 745,
+	641, 957, 866, 773, 806, 815, 659, 102, 704, 430, 106, 296, 129, 847,
+	130, 990, 669, 236, 225, 680, 159, 213, 438, 189, 447, 600, 232, 594,
+	32, 56, 390, 647, 855, 428, 330, 714, 738, 706, 666, 461, 469, 482,
+	558, 814, 559, 177, 575, 538, 309, 383, 261, 156, 420, 761, 630, 893,
+	10, 116, 940, 844, 71, 377, 662, 312, 520, 244, 143, 759, 119, 186,
+	592, 909, 864, 376, 768, 254, 265, 394, 511, 760, 574, 6, 436, 514,
+	59, 226, 644, 956, 578, 825, 548, 145, 736, 597, 378, 821, 987, 897,
+	354, 144, 722, 895, 589, 503, 826, 498, 543, 617, 763, 231, 808, 528,
+	89, 479, 607, 737, 170, 404, 371, 65, 103, 340, 283, 141, 313, 858,
+	289, 124, 971, 687, 954, 732, 39, 926, 176, 100, 267, 519, 890, 535,
+	276, 448, 27, 457, 899, 385, 184, 275, 770, 544, 614, 449, 160, 658,
+	259, 973, 108, 604, 24, 207, 562, 757, 744, 324, 444, 962, 591, 480,
+	398, 409, 998, 253, 325, 445, 979, 8, 35, 118, 73, 683, 208, 85, 190,
+	791, 408, 871, 657, 179, 18, 556, 496, 475, 20, 894, 484, 775, 889,
+	463, 241, 730, 57, 907, 551, 859, 943, 185, 416, 870, 590, 435, 471,
+	932, 268, 381, 626, 502, 565, 273, 534, 672, 778, 292, 473, 566, 104,
+	172, 285, 832, 411, 329, 628, 397, 472, 271, 910, 711, 690, 969, 585,
+	809, 941, 923, 555, 228, 685, 242, 94, 96, 211, 140, 61, 922, 795,
+	869, 34, 255, 38, 984, 676, 15, 560, 632, 434, 921, 355, 582, 351,
+	212, 200, 819, 960, 649, 852, 75, 771, 361, 996, 238, 316, 720, 671,
+	462, 112, 569, 171, 664, 625, 588, 405, 553, 270, 533, 353, 842, 114,
+	972, 83, 937, 63, 194, 237, 537, 980, 802, 916, 959, 688, 839, 350,
+	917, 650, 545, 615, 151, 352, 686, 726, 266, 509, 439, 491, 935, 608,
+	518, 653, 339, 609, 277, 635, 836, 88, 407, 440, 642, 927, 229, 727,
+	360, 477, 846, 413, 454, 616, 28, 598, 567, 540, 790, 424, 247, 317,
+	746, 911, 798, 321, 547, 248, 734, 829, 220, 138, 756, 500, 691, 196,
+	740, 930, 843, 733, 221, 827, 50, 813, 949, 525, 349, 474, 134, 875,
+	695, 513, 414, 515, 638, 99, 366, 490, 975, 246, 465, 206, 281, 583,
+	256, 587, 749, 2, 951, 679, 215, 364, 458, 402, 646, 991, 335, 982,
+	835, 300, 900, 703, 994, 983, 234, 888, 532, 804, 584, 305, 792, 442,
+	291, 964, 158, 370, 452, 250, 521, 166, 948, 812, 794, 272, 699, 205,
+	183, 507, 301, 920, 781, 233, 824, 137, 489, 833, 887, 966, 856, 78,
+	830, 153, 359, 696, 526, 216, 66, 701, 403, 891, 849, 571, 308, 483,
+	164, 293, 928, 677, 320, 837, 441, 639, 564, 510, 648, 274, 336, 661,
+	878, 777, 816, 976, 493, 810, 67, 87, 91, 187, 882, 986, 80, 22, 499,
+	90, 705, 139, 136, 122, 708, 716, 886, 572, 127, 40, 721, 764, 16,
+	379, 692, 645, 456, 710, 460, 783, 97, 776, 713, 884, 115, 466, 596,
+	374, 406, 110, 568, 68, 214, 622, 470, 107, 504, 682, 31, 421, 576,
+	654, 605, 788, 799, 280, 338, 931, 873, 204, 287, 459, 755, 939, 599,
+	431, 796, 235, 42, 750, 262, 318, 393, 202, 822, 879, 820, 728, 337,
+};
+
+static void fill_bindings_random(struct strbuf *buf, int start, int end,
+				 const char *prefix)
+{
+	int i;
+
+	for (i = start; i < end; i++) {
+		print_strbuf(buf,  "%s", prefix);
+		format_devname(buf, random_numbers[i]);
+		print_strbuf(buf,  " WWID%d\n", random_numbers[i-1]);
+	}
+}
+
+struct random_aliases {
+	int start;
+	int end;
+	const char *prefix;
+};
+
+static void order_test(int n, struct random_aliases ra[], bool conflict_ok)
+{
+	STRBUF_ON_STACK(buf);
+	int i, j, prev, curr, tmp;
+	struct binding *bdg;
+	Bindings *bindings = &global_bindings;
+
+	for (j = 0; j < n; j++)
+		fill_bindings_random(&buf, ra[j].start, ra[j].end, ra[j].prefix);
+	__mock_bindings_file(get_strbuf_str(&buf), conflict_ok);
+
+	for (j = 0; j < n; j++) {
+		bdg = VECTOR_SLOT(bindings, 0);
+		if (ALIAS_DEBUG && j == 0)
+			printf("%d: %s\n", 0, bdg->alias);
+		prev = scan_devname(bdg->alias, ra[j].prefix);
+		i = 1;
+		vector_foreach_slot_after(bindings, bdg, i) {
+			if (ALIAS_DEBUG && j == 0)
+				printf("%d: %s\n", i, bdg->alias);
+			tmp = scan_devname(bdg->alias, ra[j].prefix);
+			if (tmp == -1)
+				continue;
+			curr = tmp;
+			if (prev > 0) {
+				if (curr <= prev)
+					printf("ERROR: %d (%s) %d >= %d\n",
+					       i, bdg->alias, prev, curr);
+				assert_true(curr > prev);
+			}
+			prev = curr;
+		}
+	}
+}
+
+static void order_01(void **state)
+{
+	struct random_aliases ra[] = {
+		{  0, 1000, "MPATH" },
+	};
+
+	order_test(ARRAY_SIZE(ra), ra, false);
+}
+
+static void order_02(void **state)
+{
+	struct random_aliases ra[] = {
+		{   0, 500, "MPATH" },
+		{ 200, 700, "mpath" },
+	};
+	order_test(ARRAY_SIZE(ra), ra, false);
+}
+
+static void order_03(void **state)
+{
+	struct random_aliases ra[] = {
+		{  500, 1000, "MPTH" },
+		{    0,  500, "MPATH" },
+	};
+	order_test(ARRAY_SIZE(ra), ra, false);
+}
+
+static void order_04(void **state)
+{
+	struct random_aliases ra[] = {
+		{   0, 500, "mpa" },
+		{ 250, 750, "mp" },
+	};
+	order_test(ARRAY_SIZE(ra), ra, true);
+}
+
+static void order_05(void **state)
+{
+	struct random_aliases ra[] = {
+		{  0, 100, "A" },
+		{  0, 100, "B" },
+		{  0, 100, "C" },
+		{  0, 100, "D" },
+	};
+	order_test(ARRAY_SIZE(ra), ra, false);
+}
+
+static void order_06(void **state)
+{
+	struct random_aliases ra[] = {
+		{  0, 100, "" },
+		{  0, 100, "a" },
+		{  0, 100, "aa" },
+		{  0, 100, "ab" },
+		{  0, 100, "aaa" },
+	};
+	order_test(ARRAY_SIZE(ra), ra, true);
+}
+
+static int test_bindings_order()
+{
+	const struct CMUnitTest tests[] = {
+		cmocka_unit_test_teardown(order_01, teardown_bindings),
+		cmocka_unit_test_teardown(order_02, teardown_bindings),
+		cmocka_unit_test_teardown(order_03, teardown_bindings),
+		cmocka_unit_test_teardown(order_04, teardown_bindings),
+		cmocka_unit_test_teardown(order_05, teardown_bindings),
+		cmocka_unit_test_teardown(order_06, teardown_bindings),
+	};
+
+	return cmocka_run_group_tests(tests, NULL, NULL);
+}
+
 int main(void)
 {
 	int ret = 0;
@@ -1755,6 +1960,7 @@ int main(void)
 	ret += test_rlookup_binding();
 	ret += test_allocate_binding();
 	ret += test_get_user_friendly_alias();
+	ret += test_bindings_order();
 
 	return ret;
 }
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

