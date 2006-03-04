From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: [PATCH] Add metadata writing and hot spare processing to
	hostraid driver in dmraid
Date: Sat, 4 Mar 2006 10:14:37 +0100
Message-ID: <20060304091437.GD2966@redhat.com>
References: <4408E5F0.50208@us.ibm.com>
Reply-To: mauelshagen@redhat.com,
	"ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ataraid-list-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4408E5F0.50208@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ataraid-list>
List-Post: <mailto:ataraid-list@redhat.com>
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
Sender: ataraid-list-bounces@redhat.com
Errors-To: ataraid-list-bounces@redhat.com
To: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
Cc: dm-devel@redhat.com, Chris McDermott <lcm@us.ibm.com>
List-Id: dm-devel.ids


Darrick,

had a quick glance through your patch.

I want to handle more of this generically in libdmraid and
reuse it in the dmeventd DSO in order to avoid superfluous code duplicaton
in any metadata format handler.

More next week...

Heinz

On Fri, Mar 03, 2006 at 04:57:20PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Now that dmraid supports Adaptec HostRAID, I've turned my attention to 
> enabling support for writing metadata back to the disks, and 
> implementing rudimentary spare handling in RAID1 configurations.
> 
> The attached patch (which is admittedly very rough) does two key things. 
>  First, it implements asr_write in a more meaningful manner than what's 
> in rc10 right now; with that part of the patch, dmraid gains the ability 
> to reconfigure an array while the system is running and save the changes 
> out to disk.  To do this, I had to change a struct to a pointer to a 
> struct in asr_reservedblock to to get write_metadata to work properly. 
> Also, it turns out that a few more things in asr_write had to happen 
> (and in the correct order) for writes to succeed.  If we fail to write 
> the metadata correctly, the HostRAID BIOS wipes the entire sector during 
> the next reboot.
> 
> The second part of the patch stores spare devices in a dummy .asr_spares 
> array.  When an I/O error is noticed (via event_io), a suitable spare 
> drive is pulled from the spare pool and inserted into the failing array.
> I haven't had a chance to test this code rigorously yet, because the 
> dmeventd portions of dmraid aren't implemented yet.
> 
> So, there are two things that I'd like to see added: online 
> reconfiguration support in dmraid (which I can now test via asr_write) 
> and online spare handling.  Heinz, are you working on either of these 
> features, or should I start writing them?
> 
> --D


> _______________________________________________
> Ataraid-list mailing list
> Ataraid-list@redhat.com
> https://www.redhat.com/mailman/listinfo/ataraid-list

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Cluster and Storage Development                   56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
