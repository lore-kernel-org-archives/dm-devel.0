From: Brian De Wolf <bldewolf@cpp.edu>
Subject: multipath-tools-0.5.0 segfault with
	blacklist/blacklist_exceptions
Date: Mon, 12 Jan 2015 16:55:57 -0800
Message-ID: <20150112165557.484d9e3e@cpp.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

I was upgrading multipath-tools and noticed our old config causes the
various programs to segfault in libmultipath.  The culprit appeared to
be our blacklist entries with a vendor listed but no product (for
filtering the local disk controllers), e.g:

	blacklist {
		device {
			vendor "LSILOGIC"
		}
	}

Adding a product of .* makes things work as expected, but this
shouldn't be necessary.  It looks like this is because compiling the
product regex is optional:

http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=libmultipath/blacklist.c;h=3f9e80b6bf92502ce01a4a287d17039a1ad9c2ce;hb=HEAD#l89

But the regexec is not:

http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=libmultipath/blacklist.c;h=3f9e80b6bf92502ce01a4a287d17039a1ad9c2ce;hb=HEAD#l151

I couldn't find any posts about this and it didn't look fixed yet,
so I figured I should report the issue.
