From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Status dm-cache
Date: Sun, 25 Aug 2013 23:46:03 +0200
Message-ID: <521A7B1B.2070500@rolffokkens.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi!

I'm trying to package some tools for "SSD caching" for Fedora 20, see: 
https://bugzilla.redhat.com/show_bug.cgi?id=998543

bcache has some nice bcache-tools, and packaging progresses well: 
https://bugzilla.redhat.com/show_bug.cgi?id=999690

Packaging dm-cache however seems seems hard. I'm not aware of any 
userland tools, and using dm-cache (without them) seems quite complex. 
Looks like all kinds of math are needed to make it work, e.g. : 
http://blog.kylemanna.com/linux/2013/06/30/ssd-caching-using-dmcache-tutorial/.
- Is there a (well supported) toolset available that I'm missing?
- Is there any kind of autodetect possible, e.g. during boot?

Any information on the status of dm-cache is appreciated.

Thanks,

Rolf Fokkens
