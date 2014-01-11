From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: dm-cache for Fedora 21?
Date: Sat, 11 Jan 2014 15:56:19 +0100
Message-ID: <52D15B93.8000500@rolffokkens.nl>
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

Hi all,

For Fedora 20 I packaged bcache-tools so Fedora users are able to use 
bcache. It's not integrated in Anaconda, but users who feel confident on 
the command line will able to use bcache. The next step would be to 
include bcache support in Anaconda, which may happen in Fedora 21.

Fedora 20 seemed  to be too early to include dm-cache support, but I've 
seen a lot of activity on dm-cache on the mail list recently. So maybe 
dm-cache will be "ready" for Fedora 21? AFAIK userland support for 
dm-cache will be included in LVM2, but I don't know what the status is. 
Full integration of dm-cache in Fedora 21 would imply integration in 
Anaconda as well.

And maybe including bot bcache and dm-cache support in Anaconda is a 
little much.

What are your views on the status of dm-cache?

Rolf
