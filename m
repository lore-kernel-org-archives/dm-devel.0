From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] DM RAID: Remove duplicate code.
Date: Tue, 3 Jul 2012 23:02:14 -0500
Message-ID: <65DDD2AB-9B50-45EC-AB43-059D8E47C898@redhat.com>
References: <1340700941.19015.25.camel@f16>
	<20120704011450.GE22022@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120704011450.GE22022@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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


On Jul 3, 2012, at 8:14 PM, Alasdair G Kergon wrote:

> On Tue, Jun 26, 2012 at 03:55:41AM -0500, Jon Brassow wrote:
>> dm-raid: Remove duplicate code.
>> Code must have gotten pasted in twice somehow.  Remove redundant chunk.
> 
> I think that change is already in linux-next.

yup, in dm-support-non-power-of-two-target-max_io_len.patch.

Thanks,
 brassow
