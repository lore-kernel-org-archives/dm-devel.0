From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/4] discard updates
Date: Fri, 2 Jul 2010 11:12:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
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
To: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi

Here are update patches for Mike's discard.

The first two patches bugfixes, they should be certainly applied to RHEL6.

The third patch supports discards on composite devices --- it could be 
considered a "bugfix" if not sending discards is considered a "bug". I 
think it still can go to RHEL6.

The fourth patch is an enhancement to support discard if only some of the 
underlying devices support it.

Mikulas
