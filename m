From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 04/13] dm-rq: Adjust requeuing delays
Date: Thu, 27 Apr 2017 19:52:44 +0000
Message-ID: <1493322763.2625.10.camel@sandisk.com>
References: <20170427171126.26814-1-bart.vanassche@sandisk.com>
	<20170427171126.26814-5-bart.vanassche@sandisk.com>
	<20170427191610.GA67119@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170427191610.GA67119@redhat.com>
Content-Language: en-US
Content-ID: <C0C3F508C8E99C48A2E49A1C88F9A834@namprd04.prod.outlook.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On Thu, 2017-04-27 at 15:16 -0400, Mike Snitzer wrote:
> This call toblk_mq_delay_run_hw_queue(), while unconvincing and suspect,
> is being introduced via block core during the 4.12 merge.
> 
> But in general, this tweaking of the timeouts in such a short period
> speaks to indecision and leaves me unconvinced of what the _best_ values
> to use are.
> 
> Let's revisit this after the merge window closes, we can tweak the 100ms
> up to 500ms in both locations if you _really_ prefer that.

Hello Mike,

The 100ms was a copy/paste from the SCSI initiator code. Later I realized
that that is too fast in the dm core, e.g. when the underlying paths are
busy due to SCSI error handling.

Bart.
