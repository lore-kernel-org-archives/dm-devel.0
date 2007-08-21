From: Jim Meyering <jim@meyering.net>
Subject: avoiding unused fstatvfs call in _loop_table
Date: Tue, 21 Aug 2007 21:16:04 +0200
Message-ID: <871wdwd7gr.fsf@rho.meyering.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
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

In dmsetup/dmsetup.c's _loop_table, there's some unused code.
It see that part of it is marked as "unused", but...

    #ifdef HAVE_SYS_STATVFS_H
            struct statvfs fsbuf;
            off_t blksize;
    #endif

    ...

    #ifdef HAVE_SYS_STATVFS_H
            if (fstatvfs(fd, &fsbuf))
                    goto error;

            /* FIXME Fragment size currently unused */
            blksize = fsbuf.f_frsize;
    #endif

Outside of those two blocks, neither fsbuf nor blksize is used.
If it's not going to be used any time soon,
how about making that code so it's not even compiled?
That'd save everyone an fstatvfs call, and it would have
saved me the time of wondering and writing (and you reading) about it :-)

Assuming that's ok, which approach do you prefer:

- #undef the symbol and add a comment explaining.
- change each #ifdef to something like:

    #if defined HAVE_SYS_STATVFS_H && 0 /* disabled for now... */

...unless, the fstatvfs is actually there to serve a purpose.
Though I doubt that: the only possible thing it can do now is to
make _loop_table fail when fstatvfs returns nonzero.
