From: Mike Snitzer <msnitzer@redhat.com>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Tue, 23 Dec 2014 12:13:47 -0500 (EST)
Message-ID: <1v2g6masssbu88ans1r6lres.1419354811001@email.android.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
	<20141217230622.GC15390@redhat.com> <54943714.2040704@acm.org>
	<20141219153801.GA8697@redhat.com>
	<20141219171438.GA6347@redhat.com> <5498389D.6070909@acm.org>
	<20141222184910.GB8054@redhat.com> <54999756.70303@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0889374369485535418=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54999756.70303@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, snitzer@redhat.com, device-mapper@redhat.com, hch@infradead.org, development <dm-devel@redhat.com>, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

--===============0889374369485535418==
Content-Type: multipart/alternative;
	boundary="----=_Part_1418358_1483237778.1419354827047"

------=_Part_1418358_1483237778.1419354827047
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Sorry for top post but:

You'll likely fix this if you establish the cloned request's rq_disk member in the blk-mq branch of dm-mpath.c:__multipath_map()

Mike


Bart Van Assche <bvanassche@acm.org> wrote:

On 12/22/14 19:49, Mike Snitzer wrote:
> On Mon, Dec 22 2014 at 10:28am -0500,
> Bart Van Assche <bvanassche@acm.org> wrote:
>> Good news: with this patch my standard SRP multipath test ran fine for
>> several hours, after which I stopped the test.
> 
> Great, thanks for testing!  Did you happen to look at the performance of
> your testing?  If so, is it comparable/better/worse?

Hello Mike,

I have tried to run a performance comparison but after I had finished
the measurements without multipath and when I started multipathd I ran
into the following (typed over from the console):

BUG: unable to handle kernel NULL pointer dereference at 0000318
IP: scsi_setup_cmnd+0xe8 [scsi_mod]
Workqueue: kblockd blk_mq_run_work_fn
Call Trace:
scsi_queue_rq+0x5a5
__blk_mq_run_hw_queue+0x1cb
blk_mq_run_work_fn+0xd
process_one_work+0x133
worker_thread+0x11b
kthread+0xcd

gdb translates the above address as follows:

(gdb) list *(scsi_setup_cmnd+0xe8)
0x9568 is in scsi_setup_cmnd (include/scsi/scsi_cmnd.h:155).
150     }
151
152     /* make sure not to use it with REQ_TYPE_BLOCK_PC commands */
153     static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
154     {
155             return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
156     }
157
158     extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
159     extern void scsi_put_command(struct scsi_cmnd *);

Bart.

------=_Part_1418358_1483237778.1419354827047
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

<html><body><div><div><div>Sorry for top post but:</div><div><br/></div><di=
v>You&#39;ll likely fix this if you establish the cloned request&#39;s rq_d=
isk member in the blk-mq branch of dm-mpath.c:__multipath_map()</div><div><=
br/></div><div>Mike</div><div><br/></div></div><br><br>Bart Van Assche &lt;=
bvanassche@acm.org&gt; wrote:<br><br></div><br><div>On 12/22/14 19:49, Mike=
 Snitzer wrote:
<br>&gt; On Mon, Dec 22 2014 at 10:28am -0500,
<br>&gt; Bart Van Assche &lt;bvanassche@acm.org&gt; wrote:
<br>&gt;&gt; Good news: with this patch my standard SRP multipath test ran =
fine for
<br>&gt;&gt; several hours, after which I stopped the test.
<br>&gt;=20
<br>&gt; Great, thanks for testing! &nbsp;Did you happen to look at the per=
formance of
<br>&gt; your testing? &nbsp;If so, is it comparable/better/worse?
<br>
<br>Hello Mike,
<br>
<br>I have tried to run a performance comparison but after I had finished
<br>the measurements without multipath and when I started multipathd I ran
<br>into the following (typed over from the console):
<br>
<br>BUG: unable to handle kernel NULL pointer dereference at 0000318
<br>IP: scsi_setup_cmnd+0xe8 [scsi_mod]
<br>Workqueue: kblockd blk_mq_run_work_fn
<br>Call Trace:
<br>scsi_queue_rq+0x5a5
<br>__blk_mq_run_hw_queue+0x1cb
<br>blk_mq_run_work_fn+0xd
<br>process_one_work+0x133
<br>worker_thread+0x11b
<br>kthread+0xcd
<br>
<br>gdb translates the above address as follows:
<br>
<br>(gdb) list *(scsi_setup_cmnd+0xe8)
<br>0x9568 is in scsi_setup_cmnd (include/scsi/scsi_cmnd.h:155).
<br>150 &nbsp; &nbsp; }
<br>151
<br>152 &nbsp; &nbsp; /* make sure not to use it with REQ_TYPE_BLOCK_PC com=
mands */
<br>153 &nbsp; &nbsp; static inline struct scsi_driver *scsi_cmd_to_driver(=
struct scsi_cmnd *cmd)
<br>154 &nbsp; &nbsp; {
<br>155 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return *(struct scsi_driv=
er **)cmd-&gt;request-&gt;rq_disk-&gt;private_data;
<br>156 &nbsp; &nbsp; }
<br>157
<br>158 &nbsp; &nbsp; extern struct scsi_cmnd *scsi_get_command(struct scsi=
_device *, gfp_t);
<br>159 &nbsp; &nbsp; extern void scsi_put_command(struct scsi_cmnd *);
<br>
<br>Bart.
<br></div></body></html>
------=_Part_1418358_1483237778.1419354827047--


--===============0889374369485535418==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0889374369485535418==--
