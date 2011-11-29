From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
Date: Tue, 29 Nov 2011 10:33:46 -0600
Message-ID: <4ED5096A.8060706@redhat.com>
References: <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com> <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com> <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com> <20111129101901.GA5635@quack.suse.cz> <20111129102156.GA7463@quack.suse.cz> <Pine.LNX.4.64.1111290556270.12274@hs20-bc2-1.build.redhat.com> <20111129111136.GC5635@quack.suse.cz> <Pine.LNX.4.64.1111290746230.10352@hs20-bc2-1.build.redhat.com> <20111129130913.GE5635@quack.suse.cz> <20111129131811.GS7595@agk-dp.fab.redhat.com> <20111129133239.GA9926@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111129133239.GA9926@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Surbhi Palande <csurbhi@gmail.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christopher Chaltain <christopher.chaltain@canonical.com>, Valerie Aurora <val@vaaconsulting.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/29/11 7:32 AM, Jan Kara wrote:
> On Tue 29-11-11 13:18:11, Alasdair G Kergon wrote:
>> On Tue, Nov 29, 2011 at 02:09:13PM +0100, Jan Kara wrote:
>>>   Hmm, then why do these operations suspend the filesystem if they
>>> apparently don't need it? Sorry for my ignorance, I never seriously worked
>>> with LVM code...
>>
>> They don't suspend it if they don't need to.
>>
>> dm-ioctl.h:
>> /*
>>  * Set this to avoid attempting to freeze any filesystem when suspending.
>>  */
>> #define DM_SKIP_LOCKFS_FLAG     (1 << 10) /* In */
>   Thanks. I was now checking in detail and indeed FIFREEZE fails if
> ->freeze_fs is not set. And only xfs, ext3, ext4, reiserfs, jfs, nilfs2,
> and gfs2 provide this function. So I was correct in assuming that when
> filesystem supports FIFREEZE it must make sure no modifications happen to
> the filesystem. So I believe that my original plan for sync to skip frozen
> filesystem is correct.

Jan, FWIW I agree with this as well.

- -Eric
 
> 								Honza

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJO1QlpAAoJECCuFpLhPd7g3wEP/1C7T280LLZHubBMolF1dEp0
qJPQAcMUCcwMn+ewMZF5Pg/Li5WxveLNydzUWURrmnXolHddkvmoUESeJt6ugraT
i0bgb3ICRKpYi/1GEsW8UZQMXWIjdg5qyEvagDou/oy7qPXeND+JTvSYdqoti0Fn
pKv9ZUuU2arPrdDqCHP0lmiU1mF85/h/liB09GdFll3nLvSahJK5N9Cr6d0jG4VL
9faJSKI4EgVvyDPWx+L4mA5aIbPveQY0LbzpS+QSGswkd4ylVvLCV76oYj4jEH7R
hbv8OjgWTEKV8wgqmFFF/HXwzmJqzfT0rFCgbe4ZCJdnNujRe2h/wg5Gpkbj3lWc
htwUZfKKg9Vm9PheqMVxbRYEbWXB+g2Seiv/5fHNNG3WeFuPo15ftcu3Kjj7z/gS
zY1PnkHJj7/fF9tyZyTGb/AXicJyLJN7gWvf8pWNETXd4PfuDHgD70iQfWbZdKfe
0a+G4AGhXJ9zrjImM1vnsq09AMTQApL+Lm+VxdPfUbFBZd9pSC+xbBDKvOl8qy3A
Gllbjtbwi/3hV2S8t4vSLLowRTZqkLC+VHphnyLlwVeHAUsqZXQ58ZrFNx2NaYdL
UGkEty8zHGL08Yglwfd2iSlzDb/0OmCurXSZcAAXH47AAzPxZgN80KFbwc2PsGG7
DC9hxrb1bGZojdDTsuku
=UWkJ
-----END PGP SIGNATURE-----
