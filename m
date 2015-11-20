From: Marian Marinov <mm@siteground.com>
Subject: Re: lvremove kernel BUG at drivers/md/dm-bufio.c:1494!
Date: Fri, 20 Nov 2015 23:41:36 +0200
Message-ID: <564F9390.6020101@siteground.com>
References: <564DE740.3040104@siteground.com>
	<20151120194616.GA19332@redhat.com>
Reply-To: mm@siteground.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151120194616.GA19332@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, SiteGround Operations <operations@siteground.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Mike,

On 11/20/2015 09:46 PM, Mike Snitzer wrote:
> On Thu, Nov 19 2015 at 10:14am -0500, vaLentin chernoZemski <valentin@siteground.com> wrote:
> 
>> Hi folks,
>> 
>> It seems that there is a bug in the linux kernel in any release from
>> 
>> - 2.6.32-573.3.1.el6.x86_64 - crash - 3.12.49 + msg00123 patch - crash / D state - 4.1.6 - lv* operations in D state after bug is hit - 4.1.12 + f11a82caf / b0dc3c8bc15 - lv* operations in D state after bug is hit - 4.2.5 - lv* operations in D
>> state after bug is hit - 4.3.0-rc7-vanilla1
>> 
>> The bug is described in details and stack traces in RedHat's bugzilla under id 1219634:
>> 
>> https://bugzilla.redhat.com/show_bug.cgi?id=1219634
>> 
>> For some reason it is marked as private but I guess you have access to this one.
>> 
>> Issue is present in current latest RHEL version and all vanilla kernels I tested with multiple patches specified in the bug.
>> 
>> Even I can not provide you with exact reproducer it happens often enough on a fleet of machines we have that perform certain tasks and we can easily test new patches or provide you with specific information upon request from all crash dumps we
>> reliably collected and still collecting from all kernel versions tested.
>> 
>> I got advised by Mike Snitzer to dm-devel so here it is.
>> 
>> Let us know if there is anything we can do to assist you further.
> 
> As you know we've already had further exchanges off-list (started prior to you having sent this mail to dm-devel).
> 
> But for the benefit of others; here are some additional details not covered above: - you have a pretty extensive multi-system setup that is seeing these thinp metadata corruptions manifest as a BUG_ON in bufio.c - my theory is that even though
> we've fixed bugs in persistent-data that will likely prevent future corruption on-disk you could easily have on-disk corruption that even the new code cannot cope with. - it isn't productive for the persistent-data code to immediately BUG_ON in
> the face of this corruption - because the kernel code just does BUG_ON you're having a hard time identifying which thin-pool is hitting problems across your cluster
> 
> So in summary, we need 2 improvements moving forward: 1) the kernel code should bubble errors out to the edges; the error should cause the pool to transition to read-only mode (w/ needs_check flag set) -- a side-effect of this is we'll get
> logging of which thin-pool metadata device(s) saw the corruption
> 
> 2) we need lvm2 to simplify direct access to the pool's metadata volume to assist with more advanced troubleshooting (e.g. creating a compressed copy of the thin-pool metadata device that we can analyze)
> 

If you want I can upload a few of the crash dumps, so you can analyze them.

Also, we can easily pinpoint which were the active LVs in use.

As Valentin already pointed out, we will continue working on pinpointing corrupted thinpools and repairing them(if possible).

Finally I would like to offer our Dev help with this. We can start working on converting the BUG_ON code in bufio into WARN and introducing new flags, that will be handled by the LVM code, to remount the corrupted thinpools read-only.

Since this will be done during EU work hours I would be happy if we can discuss the actual code changes on IRC, if you like.

Marian

> Mike
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlZPk5AACgkQ4mt9JeIbjJT1lgCgyaBLjSN+r6Iatz1DwBe5zS9p
Ya0AoJoYfW8caEC2ccCOs5QeFmEkffTg
=frpV
-----END PGP SIGNATURE-----
