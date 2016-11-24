From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] dm-crypt: check key payload pointer not null
Date: Thu, 24 Nov 2016 09:28:46 +0000
Message-ID: <10923.1479979726@warthog.procyon.org.uk>
References: <1479934277-14913-1-git-send-email-okozina@redhat.com>
	<20161121154049.GA13248@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1479934277-14913-1-git-send-email-okozina@redhat.com>
Content-ID: <10922.1479979726.1@warthog.procyon.org.uk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ondrej Kozina <okozina@redhat.com>
Cc: snitzer@redhat.com, dhowells@redhat.com, dm-devel@redhat.com, mpatocka@redhat.com, aryabinin@virtuozzo.com, mbroz@redhat.com
List-Id: dm-devel.ids

Looking at:

	https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.10&id=3b0ef9ade65e299a8c13df5fe70352360c6bd05c

Reviewed-by: David Howells <dhowells@redhat.com>
