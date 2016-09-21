From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: Handling SCSI-3 PR RELEASE in
 multi-controller environment
Date: Wed, 21 Sep 2016 11:04:27 -0400
Message-ID: <20160921150427.GB9748@redhat.com>
References: <57E24F7E.4030103@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <57E24F7E.4030103@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jiangyiwen <jiangyiwen@huawei.com>
Cc: wangyibin@huawei.com, dm-devel@redhat.com, hch@lst.de
List-Id: dm-devel.ids

On Wed, Sep 21 2016 at  5:14am -0400,
jiangyiwen <jiangyiwen@huawei.com> wrote:

> Hi guys,
> 
> I'm sorry if someone else has already asked the same question before, but
> here's what we are facing with generic multipath.
> 
> We were evaluating SCSI-3 PR and hit the following issue:
> 
> Our IPSAN has two controllers (C1/C2). Our host is connected to both
> controllers. So we have 2 I_T nexus. The same key is registered on each I_T
> nexus. When we issue SCSI-3 PR RESERE through generic multipath, the
> reservation will be placed on one of the controllers (say, C1). Now if we
> issue SCSI-3 PR RELEASE, generic multipath will select _only_ one of its
> paths based on user defined path selection policy. The problem is that, if
> the selected path leads to controller C2, which does not hold the
> reservation, the reservation won't be released - and what's more, since the
> reservation is done by the same host, the RELEASE command returns
> successfully. So this gives us the illusion that the reservation is released
> but in fact it is still there.
> 
> I know that there's a user space tool mpathpersist that can handle this
> problem by issuing release command on all available paths, but here I am
> talking about doing same thing in kernel space. So my question is, is there
> anyone who is working on supporting SCSI-3 PR in a multiple controller
> environment?
> 
> Please advise. Thanks in advance!

Which kernel are you using?  Christoph (now cc'd) has introduced a new
PR api.  I merged a fix from him relatively recently (commit 9c72bad1f3
"dm: call PR reserve/unreserve on each underlying device")

Mike
