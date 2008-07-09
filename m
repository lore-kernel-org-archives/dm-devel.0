From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Tue, 8 Jul 2008 21:09:22 -0400
Message-ID: <20080709010922.GE9957__30395.3324597844$1215605285$gmane$org@mit.edu>
References: <20080630212450t-sato@mail.jp.nec.com>
	<20080701081026.GB16691@infradead.org>
	<20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed>
	<20080708232031.GE18195@elf.ucw.cz>
	<20080709005254.GQ11558@disturbed>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080709005254.GQ11558@disturbed>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@infradead.org>, Takashi Sato <t-sato@yk.jp.nec.com>, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.o
List-Id: dm-devel.ids

On Wed, Jul 09, 2008 at 10:52:54AM +1000, Dave Chinner wrote:
> If you walk enough inodes while the filesystem is frozen, it
> theoretically could happen.  Typically a filesystem is only for a
> few seconds at a time so in the real world this has never, ever been
> a problem.

I had argued for the timeout (and so it's mostly my fault that
Takashi-San included it as a feature) mainly because I was (and still
amm) deeply paranoid about the competence of the application
programers who might use this feature.  I could see them screwing up
leaving it locked forever --- perhaps when their program core dumps or
when the user types ^C and they forgot to install a signal handler,
leaving the filesystem frozen forever.

In the meantime, user applications that try to create files on that
filesystem, or write to files already opened when the filesystem are
frozen will accumulate dirty pages in the page cache, until the system
finally falls over.

Think about some of the evil perpetrated by hal and the userspace
suspend-resume scripts (and how much complexity with random XML
fragments getting parsed by various dbus plugins), and tell me with a
straight face that you would trust these modern-day desktop
application writers with this interface.  Because they *will* find
some interesting way to (ab)use it.....

Also, I didn't think the extra code complexity to implements timeouts
was *that* bad --- it seemed fairly small for the functionality.

Best regards,

						- Ted
