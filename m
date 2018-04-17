From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: multipathd will not set the iscsi session tmo after
 iscsi sesstion recovery
Date: Tue, 17 Apr 2018 14:26:38 -0500
Message-ID: <20180417192638.GL3103@octiron.msp.redhat.com>
References: <de942eab-4456-fc6d-d588-79bb7a0513e1@oracle.com>
	<2a4eb120-d1f6-f7e0-4613-0403eb1ffbba@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2a4eb120-d1f6-f7e0-4613-0403eb1ffbba@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "jianchao.wang" <jianchao.w.wang@oracle.com>
Cc: dm-devel@redhat.com, shinya.narahara@oracle.com
List-Id: dm-devel.ids

On Tue, Apr 17, 2018 at 10:11:48AM +0800, jianchao.wang wrote:
> Would anyone please provide some suggestion ?
> 
> Thanks in advance
> Jianchao
> 
> On 04/12/2018 04:46 PM, jianchao.wang wrote:
> > Hi Dear all
> > 
> > Our customer complained that the iscsi session tmo parameters doesn't match with
> > the multipath config.
> > 
> > When the iscsi session fails and do the recovery, iscsid will set parameters again.
> > But this will overwrite the ones which has been set by multipathd.
> > And multipathd will not set the iscsi session tmo parameters when path down and up.

I would rather see if iscsid could skip reseting the parameters if they have
been changed outside the program. If not, then multipathd could check
and reset the parameters whenever a path comes back up.  But if iscsid
is resetting it there, might it not be resetting it elsewhere?

-Ben

> > 
> > Is there any solution for this ?
> > 
> > Thanks
> > Jianchao
> > 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
