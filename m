From: "Nick Johnson" <arachnid@notdot.net>
Subject: Sending reads/writes to a userspace program?
Date: Wed, 16 May 2007 22:53:59 +1200
Message-ID: <a01fc5d10705160353o582e074ep428d76d2a55ff39b@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Does dm provide any way for a custom target type to redirect a read or
write to a userspace program? Or even for it to notify the program of
the read/write and wait until it gives the goahead, somewhat like the
way page faulting works? I'm wondering if it's possible to create a
target type that implements a 'remote' block device with blocks stored
on something like Amazon S3, keeping only a local cache of mapped
blocks, and fetching / writing blocks as needed.

-Nick Johnson
