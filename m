From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: open-iscsi + dm-multipath
Date: Tue, 15 Mar 2005 17:37:48 -0800
Message-ID: <20050316013748.GA12508@us.ibm.com>
References: <EA4DC661A6353747A2E5C0DE8792DDDE0812849B@orsmsx404.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EA4DC661A6353747A2E5C0DE8792DDDE0812849B@orsmsx404.amr.corp.intel.com>
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
Cc: open-iscsi@googlegroups.com
List-Id: dm-devel.ids

On Tue, Mar 15, 2005 at 04:40:01PM -0800, Caushik, Ramesh wrote:
> BTW I have seen in the case of atleast 2 different iSCSI target
> implementations (unh-iscsi and iscsi-enterprise target), the target does
> not return the physical disk id for the scsi_id callout, but returns
> manufactured values (like LINUX ISCSI for vendor, etc). Given that, how

Is that only when used on top of block devices or file systems? That makes
sense, but not if they are just passing commands through to the LUN.

> can multipath-tools create multipaths for different iscsi disks ? I am
> thinking of the case 2 iscsi servers running iscsi target software and
> talking to the same FC disk at the back-end. By running multipath-tools
> I would expect the 2 different iSCSI logical devices to be part of the
> same multipath group. But if the target software on both the servers
> returns made-up values then this scheme would break, right ? Any

What is the scsi_id output for those cases?

If the made up values are unique there is not a problem. The target could
(should?) return a vendor specific value for VPD page 0x83. Then scsi_id
prepends the vendor + model in front of that.

If the value returned is unique across all possible LUNs with the same
vendor and model, it would work OK even across different targets (i.e.
targets on different hosts or such, I don't know what iSCSI calls them).

There should be methods to make sure you always get something unique from
the target, like include the underlying LUN's VPD page 0x83, or include
the MAC address of as part of the generated id.

> comments on this one ?

Fix the targets to always return unique values.

If there is a special scsi command or such that can be sent to get a
unique value from these targets, special code could be added to scsi_id,
but it is best if VPD page 0x83 can be used.

If it is still an issue, use some other method to identify the LUNs, or
don't use multipathing with those targets.

-- Patrick Mansfield
