From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: open-iscsi + dm-multipath
Date: Wed, 16 Mar 2005 16:21:25 +0100
Message-ID: <20050316152125.GE16888@averon.dyndns.org>
References: <EA4DC661A6353747A2E5C0DE8792DDDE0812849B@orsmsx404.amr.corp.intel.com>
	<20050316013748.GA12508@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20050316013748.GA12508@us.ibm.com>
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

On Tue, Mar 15, 2005 at 05:37:48PM -0800, Patrick Mansfield wrote:
> On Tue, Mar 15, 2005 at 04:40:01PM -0800, Caushik, Ramesh wrote:
> > BTW I have seen in the case of atleast 2 different iSCSI target
> > implementations (unh-iscsi and iscsi-enterprise target), the target does
> > not return the physical disk id for the scsi_id callout, but returns
> > manufactured values (like LINUX ISCSI for vendor, etc). Given that, how
> 
> Is that only when used on top of block devices or file systems? That makes
> sense, but not if they are just passing commands through to the LUN.
> 
There is thread open on IET mailing list.
It seems an agreement is about to be reached.

Please read and comment the proposal if you care.

Regards,
cvaroqui
