From: Mikulas Patocka <mpatocka@redhat.com>
Subject: dm-bufio
Date: Thu, 13 Oct 2011 11:05:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1110131102540.25329@hs20-bc2-1.build.redhat.com>
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
To: Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi

I found a way how to shut up lockdep warnings in dm-bufio, so you can 
download new a version which uses nested locks from 
http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/

BTW. why did you move dm-bufio to persistent-data directory? What are 
other dm-bufio users (such as dm-zeroed or dm-multisnap) going to do? I 
thought dm-bufio should be a separate module available to all device 
mapper targets, such as dm-io, dm-kcopyd or so?

Mikulas
