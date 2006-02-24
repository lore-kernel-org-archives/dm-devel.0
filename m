From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] dm missing bdput/thaw_bdev at removal
Date: Fri, 24 Feb 2006 15:21:21 -0600
Message-ID: <f6118578c82e3de376ca44ac19fed545@redhat.com>
References: <43FE4DB5.5050904@ce.jp.nec.com>
	<20060224163104.GP31641@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060224163104.GP31641@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Would this explain the trouble I was having with mirroring and lock_fs?

  brassow

On Feb 24, 2006, at 10:31 AM, Alasdair G Kergon wrote:

> On Thu, Feb 23, 2006 at 07:05:09PM -0500, Jun'ichi Nomura wrote:
>> Then dm_suspend will try to freeze_bdev and wait forever.
>
>> Attached patch fixes this problem.
>
> Indeed - well spotted!
>
> Alasdair
> -- 
> agk@redhat.com
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
