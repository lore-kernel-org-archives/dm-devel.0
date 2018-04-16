From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 0/2] dm-delay flush patches
Date: Tue, 17 Apr 2018 00:33:12 +0200
Message-ID: <20180416223312.122871155@debian.vm>
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
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

These patches extend dm-delay, so that the user can select separate delay
for flush requests.

Zdenek needs to create a device with one slow sector for the purpose of
testing, so he creates a device that has three targets:
linear,delay,linear

The problem with this setup is that flushes are forwarded to all three
devices and it skews test results. So I created this patchset that allows
to set zero delay for flushes.

Mikulas
