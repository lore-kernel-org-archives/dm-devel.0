From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: Revert "dm mpath: remove unnecessary NVMe branching
 in favor of scsi_dh checks"
Date: Wed, 14 Mar 2018 16:34:03 +0000
Message-ID: <1521045242.3006.4.camel@wdc.com>
References: <20180312202808.3556-1-bart.vanassche@wdc.com>
	<20180312212314.GA30763@redhat.com> <1520890358.3469.68.camel@wdc.com>
	<20180313012346.GA31673@redhat.com> <1520959432.2638.17.camel@wdc.com>
	<20180313170210.GD2785@redhat.com> <20180313170721.GA3262@redhat.com>
	<1520961057.2638.22.camel@wdc.com> <20180313214156.GA4325@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180313214156.GA4325@redhat.com>
Content-Language: en-US
Content-ID: <530A97DDAB05814299C00CE3DF084CA3@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2018-03-13 at 17:41 -0400, Mike Snitzer wrote:
> On Tue, Mar 13 2018 at  1:10pm -0400,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> > Even if that would be the case, that can't have been the cause of what I
> > reported. Before I run any dm tests I merge the block layer, SCSI and RDMA
> > changes that are scheduled for the next kernel version into the dm tree.
> 
> Well I've rebased dm-4.16 ontop of v4.15-rc5.  If you udate to latest
> dm-4.16 and look at the following diff it is pretty clear that these
> changes will not compromise dm-mpath's "mq" mode (which you're using):
> 
> git diff 8d47e65948ddea4398892946d9e50778a316b397^..e8f74a0f00113d74ac18d6de13096f9e2f95618a -- drivers/md/dm-mpath.c
> 
> I see no reason why you'd hit hangs with requests lingering on the requeue_list

Hello Mike,

I agree with you that the hanging requests shouldn't be related to the most recent
dm changes. I will try to find some time to root-cause this myself.

Bart.
