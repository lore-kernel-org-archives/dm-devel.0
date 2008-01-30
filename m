From: malahal@us.ibm.com
Subject: Re: Multipath and getuid_callout issues
	withHPXP1024disk array
Date: Wed, 30 Jan 2008 15:33:13 -0800
Message-ID: <20080130233313.GA9525@us.ibm.com>
References: <20080130201115.GA6833@us.ibm.com>
	<2F1F44D192D1284BAA298E48C1B2A4F90234F150@exchmail03.ncogroup.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <2F1F44D192D1284BAA298E48C1B2A4F90234F150@exchmail03.ncogroup.com>
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
> create: mpath0 (05:83)
> [size=13 GB][features="0"][hwhandler="0"]
> \_ round-robin 0
>  \_ 1:0:0:0 sda 8:0   [ready]
> \_ round-robin 0
>  \_ 2:0:0:0 sde 8:64  [ready]

The above out displays two states for me. Maybe your version only
displays one.

> 1) does the actual WWID need to be in the "uid" value that multipath
> gets from the callout, or is any value that is unique to the disk good
> enough?
 
I think, it can be anything. Doesn't need to match actual WWID.

> 2) what is the character limit to the return value from the
> getuid_callout?

Old versions had it as 64 (63 actual chars) and the latest code has it
set to 128 (maybe 127 real chars)

> 3) is there a specific format that multipath is looking at for parsing
> the info in the uid value (such as vendor, model, type, serial number,
> etc), or is the unique disk identifier all that is needed?

As far as I know, it doesn't parse anything inside WWID. Make sure you
don't have any blanks in the WWID as the bindings file parser will have
trouble if you do have.
