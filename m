From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 0/4] dm-noclone patches
Date: Thu, 14 Feb 2019 16:00:02 +0100
Message-ID: <20190214150002.330814680@debian-a64.vm>
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
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Here I'm sending the dm-noclone patches. The patches improve performance
for dm-linear and dm-stripe by avoid cloning the whole bio.

I deliberately decided to not support other targets becase:
* they are more complicated, that means that we need larger noclone
  structure and large structure undoes the performance advantage
* doubling the code paths of the endio function is bad for long-term
  maintenance

Mikulas
