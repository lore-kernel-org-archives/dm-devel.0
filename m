From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: dm-multipath test scripts
Date: Fri, 19 Feb 2016 00:33:54 +0000
Message-ID: <56C662F1.8070407@ce.jp.nec.com>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <20160218171745.GA15071@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20160218171745.GA15071@redhat.com>
Content-Language: ja-JP
Content-ID: <4FBB0F237767E446B758976CFCFCB7D2@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: dm-devel.ids

Hi Mike,

On 02/19/16 02:17, Mike Snitzer wrote:
> But unfortunately I cannot get either the scsidebug or tcmloop mode to
> run against v4.5-rc4
> 
> For tcmloop, targetcli fails with:
> "Could not create ISCSIFabricModule in configFS."

Hmm, it sounds like there's unnecessary dependency in targetcli.

> (fixed by enabling CONFIG_ISCSI_TARGET under TARGET_CORE)

OK.

> I'm seeing all tests fail due to fio verification failure.  I'll need to
> inspect this further..
> 
> But the most problematic test is ./tests/test_03_dm_failpath -- it seems
> to actively break _any_ v4.5-rc kernel I try (with a never-ending flood
> of messages like "device-mapper: multipath: Failing path 8:192."); I
> haven't tried older kernels.

It seems fail/recover cycle runs too fast for I/O to make any progress.
I hit similar case and had to slow down the stress with attached patch.
Please try this. Sorry for the inconvenience.

> What is the last kernel version that your scripts have worked on?

v4.4 worked fine. I'll check with v4.5-rc4 when I get a machine.

> Taking a step back:
> These scripts don't belong in Documentation/device-mapper/mptest/ (or
> anywhere in the kernel tree for that matter).
> 
> I'd really prefer it if we could port your scripts over to the
> device-mapper-test-suite, see:
> https://github.com/jthornber/device-mapper-test-suite

Yes, I agree such a project is better place for this to live.

-- 
Jun'ichi Nomura, NEC Corporation

diff --git a/lib/failpath_dm_message b/lib/failpath_dm_message
index 1a3bcf8..5b8f28a 100755
--- a/lib/failpath_dm_message
+++ b/lib/failpath_dm_message
@@ -30,9 +30,11 @@ start_failpath_dm_message () {
 		for m in $majs; do
 			dmsetup message $MPNAME 0 "fail_path $m"
 		done
+		sleep 1
 		for m in $majs; do
 			dmsetup message $MPNAME 0 "reinstate_path $m"
 		done
+		sleep 1
 	done &
 }
 