From: "Nicholas A. Bellinger" <nick@pyxtechnologies.com>
Subject: Re: dm-multipath + iscsi-initiator-core success,
	example, and questions
Date: Fri, 01 Apr 2005 12:27:03 -0800
Message-ID: <1112387223.8176.23.camel@haakon>
References: <1112313131.14802.59.camel@haakon>
	<20050401083504.GA22636@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050401083504.GA22636@averon.dyndns.org>
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
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Ming Zhang <mingz@ele.uri.edu>, iscsi-initiator-core-devel <iscsi-initiator-core-devel@iscsi-initiator-core.org>, Mike Christie <mikenc@us.ibm.com>
List-Id: dm-devel.ids

On Fri, 2005-04-01 at 10:35 +0200, Christophe Varoqui wrote:
> On Thu, Mar 31, 2005 at 03:52:11PM -0800, Nicholas A. Bellinger wrote:
> > 
> > ...
> >
> > IO never goes back across iSCSI Channel 20.  I also noticed that this
> > does not occur every time iSCSI Channel 20 is paused.  Sometimes IO will
> > stop over iSCSI Channel 21 as well, but iSCSI Channel 20 can be started
> > and IO resumes correctly to both iSCSI Channels.
> > 
> > So my main question is this, once the iSCSI Channel is restarted and IO
> > is allowed to flow again, how does dm-multipath know that the device is
> > unlocked and online?
> > 
> It's userspace responsability to maintain the device map.
> In the current available implementation, multipathd does the path checking and reinstate offline paths when they come back up.
> 

The problem that I have been encountering is multipathd never testing
for the path (iSCSI Channel 20 in the above example) once the struct
scsi_device goes from a blocked to unblocked state.  Is there anything
that I am missing in the setup in the above example?

Thanks!

-- 
Nicholas A. Bellinger <nick@pyxtechnologies.com>
