From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Supporto for EVA3000?
Date: Wed, 7 Nov 2007 12:03:21 -0600
Message-ID: <20071107180321.GE28113@ether.msp.redhat.com>
References: <000101c82065$6e410600$cf42e3c1@pitagora.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <000101c82065$6e410600$cf42e3c1@pitagora.it>
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

On Tue, Nov 06, 2007 at 12:08:59PM +0100, Domenico Viggiani wrote:
> Good morning,
> does anyone know if the old HP EVA3000 (HSV100) disk-array is supported with
> dm-multipath shipped with Red Hat 4?

If the product name comes up as HSV100, then this version of the
firmware needs the storageworks hardware handler module to function optimally.
This is not available on the RHEL4 kernel. I have never actually used
one of these disk-arrays, but I believe that there is a firmware update for the
EVA3000 that solves this problem. You should see the product name change to
HSV110, and the device will be properly autoconfigured in RHEL4.

If for some reason you cannot update the firmware, I believe that you
can still use multipath with the device at a performance penalty. I
don't recall the best configuration for that scenario off the top of my
head.

-Ben
 
> Thanks
> -- 
> Domenico Viggiani
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
