From: malahal@us.ibm.com
Subject: Re: Multipath and getuid_callout issues with HP XP1024
	disk array
Date: Tue, 29 Jan 2008 14:18:51 -0800
Message-ID: <20080129221851.GA13346@us.ibm.com>
References: <2F1F44D192D1284BAA298E48C1B2A4F90234F141@exchmail03.ncogroup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2F1F44D192D1284BAA298E48C1B2A4F90234F141@exchmail03.ncogroup.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Greene, Rick [rick.greene@ncogroup.com] wrote:
>    I've done what I can to try to understand how all this works, but I keep
>    getting "error calling out /sbin/scsi_id -g -u -s /block/sda" when I run
>    the command "multipath -v2"
> 
> 
> 
>    I've tried a number of different things in the /etc/multipath.conf file,
>    but keep coming back to this same error.  If I run the command manually I
>    get the following:
> 
> 
> 
>    # /sbin/scsi_id -g -u -s /block/sda
> 
>    0HP______OPEN-E__________50060e80039c5a0400000000000000000000e100
> 
> 
> 
>    What's missing?  Any help greatly appreciated.

You are not missing anything. The device id is too big to fit in
multipath tools allocated memory. The program incorrectly prints that
there is a problem while executing /sbin/scsi_id but in fact the problem
lies in the program itself. You may have some old version of multipath
tools. WWID_SIZE was set to 64 bytes and that is small for your device.
Get the latest version where that macro is set to 128 or so.

Hope that helps!

--Malahal.
