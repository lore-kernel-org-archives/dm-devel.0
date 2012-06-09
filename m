From: Milan Broz <mbroz@redhat.com>
Subject: Re: [linux-lvm] LVM release 2.02.96 / git / veritysetup
Date: Sat, 09 Jun 2012 10:44:34 +0200
Message-ID: <4FD30CF2.8060505@redhat.com>
References: <20120609002308.GD15806@agk-dp.fab.redhat.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
In-Reply-To: <20120609002308.GD15806@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: linux-lvm@redhat.com, lvm-devel@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On 06/09/2012 02:23 AM, Alasdair G Kergon wrote:
> veritysetup
> -----------
> Although this release contains a userspace tool for dm-verity,
>   configure --with-verity-setup=<cryptlib>
> we think the cryptsetup package would provide a better home for this
> so watch out for an updated version in an upcoming cryptsetup release.

Please do not use this version except for experiments and do not package
it in distributions yet.

Superblock format will perhaps change a little bit and also veritysetup utility
from cryptsetup source will use different command syntax (similar to dmsetup
and cryptsetup) and get full library support through libcryptsetup.

The code is maintained in separate veritysetup branch in cryptsetup git
for now, once it get back all features it will be merged to main branch (next week).
http://code.google.com/p/cryptsetup/source/browse/?name=veritysetup

Milan

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
