Return-Path: <SRS0=7So8=MQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5762FC4338F
	for <dm-devel@archiver.kernel.org>; Sat, 24 Jul 2021 06:31:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CB0EA60E9C
	for <dm-devel@archiver.kernel.org>; Sat, 24 Jul 2021 06:31:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CB0EA60E9C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-wsGQCP5yPTuSc9JWh_0TYA-1; Sat, 24 Jul 2021 02:31:44 -0400
X-MC-Unique: wsGQCP5yPTuSc9JWh_0TYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3548E1005D4F;
	Sat, 24 Jul 2021 06:31:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B73FF19D7C;
	Sat, 24 Jul 2021 06:31:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 545C24BB7C;
	Sat, 24 Jul 2021 06:31:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16O6VRtM008245 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 24 Jul 2021 02:31:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DBEC5119021; Sat, 24 Jul 2021 06:31:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D59EE51E1
	for <dm-devel@redhat.com>; Sat, 24 Jul 2021 06:31:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61B898007B1
	for <dm-devel@redhat.com>; Sat, 24 Jul 2021 06:31:23 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-234-DGGR8rRLNgS_dMdTAXmzdg-1;
	Sat, 24 Jul 2021 02:31:20 -0400
X-MC-Unique: DGGR8rRLNgS_dMdTAXmzdg-1
Received: from [192.168.86.34] (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8EA3A20B7178;
	Fri, 23 Jul 2021 23:31:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8EA3A20B7178
To: kernel test robot <lkp@intel.com>, Mike Snitzer <snitzer@redhat.com>
References: <202107211307.WaOQR1zv-lkp@intel.com>
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Message-ID: <0780ef71-77fd-f151-36c3-5981403ca31c@linux.microsoft.com>
Date: Fri, 23 Jul 2021 23:31:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <202107211307.WaOQR1zv-lkp@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16O6VRtM008245
X-loop: dm-devel@redhat.com
Cc: clang-built-linux@googlegroups.com, dm-devel@redhat.com,
	kbuild-all@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [dm:for-next 9/10] drivers/md/dm-raid.c:3686:39:
 warning: variable 'recovery' is uninitialized when used here
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed


On 7/20/21 10:51 PM, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/lin=
ux-dm.git for-next
> head:   e820ba87f9d15399fa565ceba4a92b902c879d29
> commit: fdac9de80c2e66d6df999ac810382c66b0cb2830 [9/10] dm: update target=
 status functions to support IMA measurement
> config: x86_64-randconfig-a011-20210720 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project c781=
eb153bfbd1b52b03efe34f56bbeccbb8aba6)
> reproduce (this is a W=3D1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sb=
in/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # install x86_64 cross compiling tool for clang build
>          # apt-get install binutils-x86-64-linux-gnu
>          # https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/=
linux-dm.git/commit/?id=3Dfdac9de80c2e66d6df999ac810382c66b0cb2830
>          git remote add dm https://git.kernel.org/pub/scm/linux/kernel/gi=
t/device-mapper/linux-dm.git
>          git fetch --no-tags dm for-next
>          git checkout fdac9de80c2e66d6df999ac810382c66b0cb2830
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross A=
RCH=3Dx86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>>> drivers/md/dm-raid.c:3686:39: warning: variable 'recovery' is uninitial=
ized when used here [-Wuninitialized]
>                     state =3D decipher_sync_action(mddev, recovery);
Thanks Mike for fixing this warning in the latest patch in for-next with:

+=A0=A0=A0=A0 recovery =3D rs->md.recovery;
 =A0=A0=A0=A0=A0 state =3D decipher_sync_action(mddev, recovery);

Appreciate it.

Thanks,
Tushar
>                                                         ^~~~~~~~
>     drivers/md/dm-raid.c:3517:24: note: initialize the variable 'recovery=
' to silence this warning
>             unsigned long recovery;
>                                   ^
>                                    =3D 0
>     1 warning generated.
>
>
> vim +/recovery +3686 drivers/md/dm-raid.c
>
>    3509=09
>    3510=09static void raid_status(struct dm_target *ti, status_type_t typ=
e,
>    3511=09=09=09=09unsigned int status_flags, char *result, unsigned int =
maxlen)
>    3512=09{
>    3513=09=09struct raid_set *rs =3D ti->private;
>    3514=09=09struct mddev *mddev =3D &rs->md;
>    3515=09=09struct r5conf *conf =3D mddev->private;
>    3516=09=09int i, max_nr_stripes =3D conf ? conf->max_nr_stripes : 0;
>    3517=09=09unsigned long recovery;
>    3518=09=09unsigned int raid_param_cnt =3D 1; /* at least 1 for chunksi=
ze */
>    3519=09=09unsigned int sz =3D 0;
>    3520=09=09unsigned int rebuild_writemostly_count =3D 0;
>    3521=09=09sector_t progress, resync_max_sectors, resync_mismatches;
>    3522=09=09enum sync_state state;
>    3523=09=09struct raid_type *rt;
>    3524=09
>    3525=09=09switch (type) {
>    3526=09=09case STATUSTYPE_INFO:
>    3527=09=09=09/* *Should* always succeed */
>    3528=09=09=09rt =3D get_raid_type_by_ll(mddev->new_level, mddev->new_l=
ayout);
>    3529=09=09=09if (!rt)
>    3530=09=09=09=09return;
>    3531=09
>    3532=09=09=09DMEMIT("%s %d ", rt->name, mddev->raid_disks);
>    3533=09
>    3534=09=09=09/* Access most recent mddev properties for status output =
*/
>    3535=09=09=09smp_rmb();
>    3536=09=09=09/* Get sensible max sectors even if raid set not yet star=
ted */
>    3537=09=09=09resync_max_sectors =3D test_bit(RT_FLAG_RS_PRERESUMED, &r=
s->runtime_flags) ?
>    3538=09=09=09=09=09      mddev->resync_max_sectors : mddev->dev_sector=
s;
>    3539=09=09=09recovery =3D rs->md.recovery;
>    3540=09=09=09state =3D decipher_sync_action(mddev, recovery);
>    3541=09=09=09progress =3D rs_get_progress(rs, recovery, state, resync_=
max_sectors);
>    3542=09=09=09resync_mismatches =3D (mddev->last_sync_action && !strcas=
ecmp(mddev->last_sync_action, "check")) ?
>    3543=09=09=09=09=09    atomic64_read(&mddev->resync_mismatches) : 0;
>    3544=09
>    3545=09=09=09/* HM FIXME: do we want another state char for raid0? It =
shows 'D'/'A'/'-' now */
>    3546=09=09=09for (i =3D 0; i < rs->raid_disks; i++)
>    3547=09=09=09=09DMEMIT(__raid_dev_status(rs, &rs->dev[i].rdev));
>    3548=09
>    3549=09=09=09/*
>    3550=09=09=09 * In-sync/Reshape ratio:
>    3551=09=09=09 *  The in-sync ratio shows the progress of:
>    3552=09=09=09 *   - Initializing the raid set
>    3553=09=09=09 *   - Rebuilding a subset of devices of the raid set
>    3554=09=09=09 *  The user can distinguish between the two by referring
>    3555=09=09=09 *  to the status characters.
>    3556=09=09=09 *
>    3557=09=09=09 *  The reshape ratio shows the progress of
>    3558=09=09=09 *  changing the raid layout or the number of
>    3559=09=09=09 *  disks of a raid set
>    3560=09=09=09 */
>    3561=09=09=09DMEMIT(" %llu/%llu", (unsigned long long) progress,
>    3562=09=09=09=09=09     (unsigned long long) resync_max_sectors);
>    3563=09
>    3564=09=09=09/*
>    3565=09=09=09 * v1.5.0+:
>    3566=09=09=09 *
>    3567=09=09=09 * Sync action:
>    3568=09=09=09 *   See Documentation/admin-guide/device-mapper/dm-raid.=
rst for
>    3569=09=09=09 *   information on each of these states.
>    3570=09=09=09 */
>    3571=09=09=09DMEMIT(" %s", sync_str(state));
>    3572=09
>    3573=09=09=09/*
>    3574=09=09=09 * v1.5.0+:
>    3575=09=09=09 *
>    3576=09=09=09 * resync_mismatches/mismatch_cnt
>    3577=09=09=09 *   This field shows the number of discrepancies found w=
hen
>    3578=09=09=09 *   performing a "check" of the raid set.
>    3579=09=09=09 */
>    3580=09=09=09DMEMIT(" %llu", (unsigned long long) resync_mismatches);
>    3581=09
>    3582=09=09=09/*
>    3583=09=09=09 * v1.9.0+:
>    3584=09=09=09 *
>    3585=09=09=09 * data_offset (needed for out of space reshaping)
>    3586=09=09=09 *   This field shows the data offset into the data
>    3587=09=09=09 *   image LV where the first stripes data starts.
>    3588=09=09=09 *
>    3589=09=09=09 * We keep data_offset equal on all raid disks of the set=
,
>    3590=09=09=09 * so retrieving it from the first raid disk is sufficien=
t.
>    3591=09=09=09 */
>    3592=09=09=09DMEMIT(" %llu", (unsigned long long) rs->dev[0].rdev.data=
_offset);
>    3593=09
>    3594=09=09=09/*
>    3595=09=09=09 * v1.10.0+:
>    3596=09=09=09 */
>    3597=09=09=09DMEMIT(" %s", test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_f=
lags) ?
>    3598=09=09=09=09      __raid_dev_status(rs, &rs->journal_dev.rdev) : "=
-");
>    3599=09=09=09break;
>    3600=09
>    3601=09=09case STATUSTYPE_TABLE:
>    3602=09=09=09/* Report the table line string you would use to construc=
t this raid set */
>    3603=09
>    3604=09=09=09/*
>    3605=09=09=09 * Count any rebuild or writemostly argument pairs and su=
btract the
>    3606=09=09=09 * hweight count being added below of any rebuild and wri=
temostly ctr flags.
>    3607=09=09=09 */
>    3608=09=09=09for (i =3D 0; i < rs->raid_disks; i++) {
>    3609=09=09=09=09rebuild_writemostly_count +=3D (test_bit(i, (void *) r=
s->rebuild_disks) ? 2 : 0) +
>    3610=09=09=09=09=09=09=09     (test_bit(WriteMostly, &rs->dev[i].rdev.=
flags) ? 2 : 0);
>    3611=09=09=09}
>    3612=09=09=09rebuild_writemostly_count -=3D (test_bit(__CTR_FLAG_REBUI=
LD, &rs->ctr_flags) ? 2 : 0) +
>    3613=09=09=09=09=09=09     (test_bit(__CTR_FLAG_WRITE_MOSTLY, &rs->ctr=
_flags) ? 2 : 0);
>    3614=09=09=09/* Calculate raid parameter count based on ^ rebuild/writ=
emostly argument counts and ctr flags set. */
>    3615=09=09=09raid_param_cnt +=3D rebuild_writemostly_count +
>    3616=09=09=09=09=09  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_NO_ARG=
S) +
>    3617=09=09=09=09=09  hweight32(rs->ctr_flags & CTR_FLAG_OPTIONS_ONE_AR=
G) * 2;
>    3618=09=09=09/* Emit table line */
>    3619=09=09=09/* This has to be in the documented order for userspace! =
*/
>    3620=09=09=09DMEMIT("%s %u %u", rs->raid_type->name, raid_param_cnt, m=
ddev->new_chunk_sectors);
>    3621=09=09=09if (test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags))
>    3622=09=09=09=09DMEMIT(" %s", dm_raid_arg_name_by_flag(CTR_FLAG_SYNC))=
;
>    3623=09=09=09if (test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags))
>    3624=09=09=09=09DMEMIT(" %s", dm_raid_arg_name_by_flag(CTR_FLAG_NOSYNC=
));
>    3625=09=09=09if (test_bit(__CTR_FLAG_REBUILD, &rs->ctr_flags))
>    3626=09=09=09=09for (i =3D 0; i < rs->raid_disks; i++)
>    3627=09=09=09=09=09if (test_bit(i, (void *) rs->rebuild_disks))
>    3628=09=09=09=09=09=09DMEMIT(" %s %u", dm_raid_arg_name_by_flag(CTR_FL=
AG_REBUILD), i);
>    3629=09=09=09if (test_bit(__CTR_FLAG_DAEMON_SLEEP, &rs->ctr_flags))
>    3630=09=09=09=09DMEMIT(" %s %lu", dm_raid_arg_name_by_flag(CTR_FLAG_DA=
EMON_SLEEP),
>    3631=09=09=09=09=09=09  mddev->bitmap_info.daemon_sleep);
>    3632=09=09=09if (test_bit(__CTR_FLAG_MIN_RECOVERY_RATE, &rs->ctr_flags=
))
>    3633=09=09=09=09DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_MIN=
_RECOVERY_RATE),
>    3634=09=09=09=09=09=09 mddev->sync_speed_min);
>    3635=09=09=09if (test_bit(__CTR_FLAG_MAX_RECOVERY_RATE, &rs->ctr_flags=
))
>    3636=09=09=09=09DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_MAX=
_RECOVERY_RATE),
>    3637=09=09=09=09=09=09 mddev->sync_speed_max);
>    3638=09=09=09if (test_bit(__CTR_FLAG_WRITE_MOSTLY, &rs->ctr_flags))
>    3639=09=09=09=09for (i =3D 0; i < rs->raid_disks; i++)
>    3640=09=09=09=09=09if (test_bit(WriteMostly, &rs->dev[i].rdev.flags))
>    3641=09=09=09=09=09=09DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FL=
AG_WRITE_MOSTLY),
>    3642=09=09=09=09=09=09       rs->dev[i].rdev.raid_disk);
>    3643=09=09=09if (test_bit(__CTR_FLAG_MAX_WRITE_BEHIND, &rs->ctr_flags)=
)
>    3644=09=09=09=09DMEMIT(" %s %lu", dm_raid_arg_name_by_flag(CTR_FLAG_MA=
X_WRITE_BEHIND),
>    3645=09=09=09=09=09=09  mddev->bitmap_info.max_write_behind);
>    3646=09=09=09if (test_bit(__CTR_FLAG_STRIPE_CACHE, &rs->ctr_flags))
>    3647=09=09=09=09DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_STR=
IPE_CACHE),
>    3648=09=09=09=09=09=09 max_nr_stripes);
>    3649=09=09=09if (test_bit(__CTR_FLAG_REGION_SIZE, &rs->ctr_flags))
>    3650=09=09=09=09DMEMIT(" %s %llu", dm_raid_arg_name_by_flag(CTR_FLAG_R=
EGION_SIZE),
>    3651=09=09=09=09=09=09   (unsigned long long) to_sector(mddev->bitmap_=
info.chunksize));
>    3652=09=09=09if (test_bit(__CTR_FLAG_RAID10_COPIES, &rs->ctr_flags))
>    3653=09=09=09=09DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_RAI=
D10_COPIES),
>    3654=09=09=09=09=09=09 raid10_md_layout_to_copies(mddev->layout));
>    3655=09=09=09if (test_bit(__CTR_FLAG_RAID10_FORMAT, &rs->ctr_flags))
>    3656=09=09=09=09DMEMIT(" %s %s", dm_raid_arg_name_by_flag(CTR_FLAG_RAI=
D10_FORMAT),
>    3657=09=09=09=09=09=09 raid10_md_layout_to_format(mddev->layout));
>    3658=09=09=09if (test_bit(__CTR_FLAG_DELTA_DISKS, &rs->ctr_flags))
>    3659=09=09=09=09DMEMIT(" %s %d", dm_raid_arg_name_by_flag(CTR_FLAG_DEL=
TA_DISKS),
>    3660=09=09=09=09=09=09 max(rs->delta_disks, mddev->delta_disks));
>    3661=09=09=09if (test_bit(__CTR_FLAG_DATA_OFFSET, &rs->ctr_flags))
>    3662=09=09=09=09DMEMIT(" %s %llu", dm_raid_arg_name_by_flag(CTR_FLAG_D=
ATA_OFFSET),
>    3663=09=09=09=09=09=09   (unsigned long long) rs->data_offset);
>    3664=09=09=09if (test_bit(__CTR_FLAG_JOURNAL_DEV, &rs->ctr_flags))
>    3665=09=09=09=09DMEMIT(" %s %s", dm_raid_arg_name_by_flag(CTR_FLAG_JOU=
RNAL_DEV),
>    3666=09=09=09=09=09=09__get_dev_name(rs->journal_dev.dev));
>    3667=09=09=09if (test_bit(__CTR_FLAG_JOURNAL_MODE, &rs->ctr_flags))
>    3668=09=09=09=09DMEMIT(" %s %s", dm_raid_arg_name_by_flag(CTR_FLAG_JOU=
RNAL_MODE),
>    3669=09=09=09=09=09=09 md_journal_mode_to_dm_raid(rs->journal_dev.mode=
));
>    3670=09=09=09DMEMIT(" %d", rs->raid_disks);
>    3671=09=09=09for (i =3D 0; i < rs->raid_disks; i++)
>    3672=09=09=09=09DMEMIT(" %s %s", __get_dev_name(rs->dev[i].meta_dev),
>    3673=09=09=09=09=09=09 __get_dev_name(rs->dev[i].data_dev));
>    3674=09=09=09break;
>    3675=09
>    3676=09=09case STATUSTYPE_IMA:
>    3677=09=09=09rt =3D get_raid_type_by_ll(mddev->new_level, mddev->new_l=
ayout);
>    3678=09=09=09if (!rt)
>    3679=09=09=09=09return;
>    3680=09
>    3681=09=09=09DMEMIT_TARGET_NAME_VERSION(ti->type);
>    3682=09=09=09DMEMIT(",raid_type=3D%s,raid_disks=3D%d", rt->name, mddev=
->raid_disks);
>    3683=09
>    3684=09=09=09/* Access most recent mddev properties for status output =
*/
>    3685=09=09=09smp_rmb();
>> 3686=09=09=09state =3D decipher_sync_action(mddev, recovery);
>    3687=09=09=09DMEMIT(",raid_state=3D%s", sync_str(state));
>    3688=09
>    3689=09=09=09for (i =3D 0; i < rs->raid_disks; i++) {
>    3690=09=09=09=09DMEMIT(",raid_device_%d_status=3D", i);
>    3691=09=09=09=09DMEMIT(__raid_dev_status(rs, &rs->dev[i].rdev));
>    3692=09=09=09}
>    3693=09
>    3694=09=09=09if (rt_is_raid456(rt)) {
>    3695=09=09=09=09DMEMIT(",journal_dev_mode=3D");
>    3696=09=09=09=09switch (rs->journal_dev.mode) {
>    3697=09=09=09=09case R5C_JOURNAL_MODE_WRITE_THROUGH:
>    3698=09=09=09=09=09DMEMIT("%s",
>    3699=09=09=09=09=09       _raid456_journal_mode[R5C_JOURNAL_MODE_WRITE=
_THROUGH].param);
>    3700=09=09=09=09=09break;
>    3701=09=09=09=09case R5C_JOURNAL_MODE_WRITE_BACK:
>    3702=09=09=09=09=09DMEMIT("%s",
>    3703=09=09=09=09=09       _raid456_journal_mode[R5C_JOURNAL_MODE_WRITE=
_BACK].param);
>    3704=09=09=09=09=09break;
>    3705=09=09=09=09default:
>    3706=09=09=09=09=09DMEMIT("invalid");
>    3707=09=09=09=09=09break;
>    3708=09=09=09=09}
>    3709=09=09=09}
>    3710=09=09=09DMEMIT(";");
>    3711=09=09=09break;
>    3712=09=09}
>    3713=09}
>    3714=09
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

