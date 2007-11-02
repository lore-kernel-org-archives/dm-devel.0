From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: Does dm handle tape devices?
Date: Fri, 2 Nov 2007 12:51:26 -0700
Message-ID: <20071102195126.GA3712@linux.vnet.ibm.com>
References: <B6FF36386FC9AC4BB098A4528811409F4B7802@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <B6FF36386FC9AC4BB098A4528811409F4B7802@CORPUSMX40A.corp.emc.com>
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

lemons_terry@emc.com <lemons_terry@emc.com> wrote:
> Hi
> 
> I need to provide persistent binding / persistent device naming for tape devices in Linux environments.  Does device mapper provide some facility for this, or is DM only for disk devices?
> 

Device mapper is only for block devices.

I saw your similar question on the udev list. Is there some reason that
udev will not provide a id that you can use. If not you can alter the
udev rules (or add your own) to provide a persistent id for your
environment.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
