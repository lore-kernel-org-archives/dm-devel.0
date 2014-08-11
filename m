From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: convert dm_ulog_request data to little endian
Date: Mon, 11 Aug 2014 10:03:48 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1408110948440.26074@file01.intranet.prod.int.rdu2.redhat.com>
References: <1407459365-697-1-git-send-email-dmzhang@suse.com>
	<20140811031556.GA27789@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140811031556.GA27789@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Dongmao Zhang <dmzhang@suse.com>
List-Id: dm-devel.ids



On Sun, 10 Aug 2014, Mike Snitzer wrote:

> On Thu, Aug 07 2014 at  8:56pm -0400,
> Dongmao Zhang <dmzhang@suse.com> wrote:
> 
> > the dm_ulog_request might be little endian or big endian depending on
> > the architecture. This is not right. This patch is to convert
> > dm_ulog_request to little endian.
> > 
> > I met a bug when running cmirrord on s390 linux
> > 
> > Signed-off-by: Dongmao Zhang <dmzhang@suse.com>
> > ---
> >  drivers/md/dm-log-userspace-transfer.c | 31 ++++++++++++++++++++++++++++++-
> >  1 file changed, 30 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
> > index b428c0a..cddef2f 100644
> > --- a/drivers/md/dm-log-userspace-transfer.c
> > +++ b/drivers/md/dm-log-userspace-transfer.c
> > @@ -53,6 +53,29 @@ struct receiving_pkg {
> >  static DEFINE_SPINLOCK(receiving_list_lock);
> >  static struct list_head receiving_list;
> >  
> > +static void cpu_to_network(struct dm_ulog_request *tfr)
> > +{
> > +	if (tfr == NULL)
> > +		return;
> > +	tfr->luid = cpu_to_le64(tfr->luid);
> > +	tfr->version =  cpu_to_le32(tfr->version);
> > +	tfr->seq = cpu_to_le32(tfr->seq);
> > +	tfr->request_type = cpu_to_le32(tfr->request_type);
> > +	tfr->data_size = cpu_to_le32(tfr->data_size);
> > +}
> > +
> > +static void network_to_cpu(struct dm_ulog_request *tfr)
> > +{
> > +	if (tfr == NULL)
> > +		return;
> > +	tfr->luid = le64_to_cpu(tfr->luid);
> > +	tfr->version =  le32_to_cpu(tfr->version);
> > +	tfr->seq = le32_to_cpu(tfr->seq);
> > +	tfr->request_type = le32_to_cpu(tfr->request_type);
> > +	tfr->data_size = le32_to_cpu(tfr->data_size);
> > +	tfr->error = le32_to_cpu(tfr->error);
> > +}
> > +
> >  static int dm_ulog_sendto_server(struct dm_ulog_request *tfr)
> >  {
> >  	int r;
> > @@ -66,6 +89,7 @@ static int dm_ulog_sendto_server(struct dm_ulog_request *tfr)
> >  	msg->seq = tfr->seq;
> >  	msg->len = sizeof(struct dm_ulog_request) + tfr->data_size;
> >  
> > +	cpu_to_network(tfr);
> >  	r = cn_netlink_send(msg, 0, 0, gfp_any());
> >  
> >  	return r;
> > @@ -81,8 +105,11 @@ static int dm_ulog_sendto_server(struct dm_ulog_request *tfr)
> >   */
> >  static int fill_pkg(struct cn_msg *msg, struct dm_ulog_request *tfr)
> >  {
> > -	uint32_t rtn_seq = (msg) ? msg->seq : (tfr) ? tfr->seq : 0;
> >  	struct receiving_pkg *pkg;
> > +	uint32_t rtn_seq;
> > +
> > +	network_to_cpu(tfr);
> > +	rtn_seq = (msg) ? msg->seq : (tfr) ? tfr->seq : 0;
> >  
> >  	/*
> >  	 * The 'receiving_pkg' entries in this list are statically
> > @@ -148,6 +175,8 @@ static void cn_ulog_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
> >  	spin_unlock(&receiving_list_lock);
> >  }
> >  
> > +
> > +
> >  /**
> >   * dm_consult_userspace
> >   * @uuid: log's universal unique identifier (must be DM_UUID_LEN in size)
> 
> Other than this last hunk (extra whitespace) this patch looks fine to me.
> 
> Jon/Mikulas/Alasdair: could you review this too?  If you guys agree I'll
> get it staged for 3.17 (and mark it for stable).
> 
> Thanks,
> Mike

Hi

Red Hat is shipping RHEL7 on s390x and ppc64, so why haven't QA caught 
this?

Is there a possibility that this patch fixes one case and breaks some 
other case?

There is a risk that we fix one userspace program that assumes messages to 
be in little endian and break another userspace program that assumes that 
the messages are in native endian - to avoid this risk, it may be better 
to fix the userspace program and leave the kernel unchanged.

I think you need to find the piece of userspace code that processes the 
information on the netlink socket and explain why it needs the information 
in little endian. (and you also need to show that there is no userspace 
code that expects the data in native endian).

Mikulas
