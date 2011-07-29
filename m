From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: Multipath and primary pathing
Date: Fri, 29 Jul 2011 09:49:33 -0500
Message-ID: <20110729144933.GI1368@ether.msp.redhat.com>
References: <3a5d511695512692af65265d6f9fa159.squirrel@www.sysadmininc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3a5d511695512692af65265d6f9fa159.squirrel@www.sysadmininc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: nigel@sysadmininc.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jul 27, 2011 at 09:02:13AM -0500, Nigel Reed wrote:
> Hi Christophe, and dev team.
> 
> I didn't see a mailing list so I hope you don't mind a direct email.
> 
> I have a customer who is using a netapp with primary and partner pathing.
> It looks like data is being sent between the two paths. The customer is
> wanting data to go down only the primary path unless it fails, then switch
> to the secondary partner path.
> 
> I've tried several different configurations but cannot seem to get it to
> work.

If I could have a look at

/etc/multipath.conf

and the output of

# multipath -ll

it would be easier to guess what's going on.

-Ben

> 
> They're using a combination of RHEL 4.9 and 5.6 with the earliest version
> of multipath being 4.5
> 
> If you can give me some help, I'd appreciate it.
> 
> Thanks,
> Nigel
> -- 
> Nigel Reed
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
