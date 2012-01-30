From: Joe Thornber <thornber@redhat.com>
Subject: Re: =?utf-8?b?W2xpbnV4LWx2bV0g562U5aSNOiBOZXcgTFZNMiBy?=
 =?utf-8?q?elease_2=2E02=2E89=3A_Thinly-provisioned_logical=3Fvolumes?=
Date: Mon, 30 Jan 2012 09:43:37 +0000
Message-ID: <20120130094336.GA4264@ubuntu>
References: <20120127025701.GB16767@agk-dp.fab.redhat.com>
	<A0D9F519724C4648B433C8FA859E3EBB7CD0390C@EX01.sogou-inc.com>
Reply-To: LVM2 development <lvm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <lvm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <A0D9F519724C4648B433C8FA859E3EBB7CD0390C@EX01.sogou-inc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/lvm-devel>
List-Post: <mailto:lvm-devel@redhat.com>
List-Help: <mailto:lvm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/lvm-devel>,
	<mailto:lvm-devel-request@redhat.com?subject=subscribe>
Sender: lvm-devel-bounces@redhat.com
Errors-To: lvm-devel-bounces@redhat.com
To: LVM general discussion and development <linux-lvm@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "lvm-devel@redhat.com" <lvm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 30, 2012 at 06:29:54AM +0000, Kirby Zhou wrote:
> Can the thinly-provisioned logical volume automatically return its owned space to the pool?
> I mean, if I create a huge file on the logical volume, then delete it, will the logical volume actual space size be reduced automatically?
> If not, how can it be shrinked?


Discard support is currently in testing.  Should go upstream soon.

- Joe

--
lvm-devel mailing list
lvm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/lvm-devel
