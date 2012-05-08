From: Joe Thornber <thornber@redhat.com>
Subject: Re: Does dm-thin support GC (garbage collection) ?
Date: Tue, 8 May 2012 11:30:33 +0100
Message-ID: <20120508103032.GB4034@ubuntu>
References: <CAJv3x-Xk-aODfJtqCEBKPM1jkwXEFVN40EEu_hnnDZB9o4dBWw@mail.gmail.com>
	<20120507132242.GA27715@redhat.com>
	<CAJv3x-USC=8z7Kz_-p8uOiQkdE21Oe0isMeDOBKRc4semHbLCA@mail.gmail.com>
	<CAJv3x-U1VRyq1m6oJQ0X8nn4WSiAzVnqm7CLuPGj-xmDh8c1AQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAJv3x-U1VRyq1m6oJQ0X8nn4WSiAzVnqm7CLuPGj-xmDh8c1AQ@mail.gmail.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Tue, May 08, 2012 at 03:21:31PM +0800, Busby wrote:
>    I have tested that the blocks were reused in the other thin-lun of
> this pool  when deleted a thin-lun .
>    How can the blocks allocated for the thin-lun be dynamically
> reclaimed? (use some method like 'discard' to tell the pool which
> block should be reclaimed and whether the pool can reclaim it ?).
>    When I mounted a filesystem on a thin-lun, create 4G bytes file
> firstly, the pool have decreased  4G space, then I deleted the file,
> the pool did not increase the size as I thought, after this, create a
> 5G file, then the pool would decrease 1G size. So I think if the

Have you enabled discard support in both the thin-pool _and_ the
filesystem?  Have you confirmed that the filesystem issues the discard
in your test scenario?  (eg, via blktrace).

- Joe
