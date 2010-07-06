From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Rescan for new LUNs
Date: Tue, 06 Jul 2010 11:29:49 +0100
Message-ID: <4C33059D.5030708@redhat.com>
References: <230ED15F81AFD3409345FFA4E565F0E50B83D8E1@NDHV3000.na.corp.mckesson.com>	<4C2C3BD1.2070207@held.org.il>
	<230ED15F81AFD3409345FFA4E565F0E50B8B58D4@NDHV3000.na.corp.mckesson.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <230ED15F81AFD3409345FFA4E565F0E50B8B58D4@NDHV3000.na.corp.mckesson.com>
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

On 07/01/2010 06:43 PM, Allen, Jack wrote:
> That sounds more like what I am looking for. But I can not find the script on my 
> system or what provides it via "yum provides". I am running RHEL 5.5.
> We have customers that run an Application that needs to be up 24*7. They some 
> times need to add additional storage and when attached to a SAN they would 
> prefer not to have to take the Application down and reboot the system just to 
> make the new LUNs be seen by the system.
> -----
> Jack Allen
> 
> --------------------------------------------------------------------------------
> *From:* dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] *On 
> Behalf Of *Oren Held
> *Sent:* Thursday, July 01, 2010 2:55 AM
> *To:* dm-devel@redhat.com
> *Subject:* Re: [dm-devel] Rescan for new LUNs
> 
> It's not an easy process.
> 
> The rescan-scsi-bus.sh script was added in recent RHEL5 updates, already in old 
> SLES. I guess it's becoming kind of a standard.

The script was originally written by Kurt Garloff but it's been included
in the sg3_utils tarball for years:

Changelog for sg3_utils-0.99 [20020317]
----------------------------
  - add 'fua' and 'sync' arguments to sg_dd, sgp_dd and sgm_dd
  - improve sg_inq, add "-cl" and "-36" arguments
  - add sg_modes + sg_logs for MODE SENSE and LOG SENSE queries
  - add rescan-scsi-bus.sh [Kurt Garloff] to archive director

It's only recently been included in the build for RHEL packages though
(5.3 iirc) - just yum install sg3_utils to get the script on a RHEL-5
system (as well as other useful bits like sg_map and friends).

The script may work for some combinations of storage and controller in
earlier RHEL versions but isn't included in the distribution and is not
always perfectly reliable.

If you need to add/remove storage on these older releases you can use
the simple scsi-add/remove-single-device interface via /proc/scsi/scsi.

If you have access to the Red Hat knowledge base (RHN login) there's an
article that explains the options on RHEL systems:

https://access.redhat.com/kb/docs/DOC-3942

And there's the RHEL5 Online Storage Reconfiguration Guide here:

http://tinyurl.com/ya6wmce [www.redhat.com]

That documents these interfaces as well as the FC and iSCSI APIs and
their relation to other components such as multipath.

Regards,
Bryn.
