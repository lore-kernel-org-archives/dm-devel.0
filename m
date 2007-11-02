From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: Does dm handle tape devices?
Date: Fri, 2 Nov 2007 14:20:48 -0700
Message-ID: <20071102212048.GA4711@linux.vnet.ibm.com>
References: <B6FF36386FC9AC4BB098A4528811409F4B7802@CORPUSMX40A.corp.emc.com>
	<20071102195126.GA3712@linux.vnet.ibm.com>
	<B6FF36386FC9AC4BB098A4528811409F4B7882@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <B6FF36386FC9AC4BB098A4528811409F4B7882@CORPUSMX40A.corp.emc.com>
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
> A third application, alas, uses SCSI IDs to refer to the tape devices.
> I've been instructed to seek a persistent naming solution for this
> application, too, one that (hopefully) won't require modification of the
> application.  I started out looking at the QLogic FC HBA's persistence
> capability, and saw that it functions at the target level within a
> single HBA.  But I found that some vendors don't support this method of
> persistence, opting instead to use device mapper.
> 

If the "third application" is wanting a I:T:L nexus for some type of
passthrough SG_IO operation I assume someone must provide the device nodes
to the application to open for its operations (config file??).

Since this is not device mapper specific maybe send me a reply offlist and
maybe I can help guide your request back to the proper list for more
discussion.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
