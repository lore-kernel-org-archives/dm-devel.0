From: Mikulas Patocka <mpatocka@redhat.com>
Subject: dm-crypt accepts '+' in the key
Date: Sat, 12 Nov 2016 15:20:54 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1611121511510.26536@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Kozina <okozina@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi

dm-crypt uses the function kstrtou8 to decode the encryption key. kstrtou8 
calls kstrtoull and kstrtoull skips the first character if it is '+'.

Consequently, it is possible to load keys with '+' in it. For example, 
this is possible:

dmsetup create cr --table "0 131072 crypt aes-cbc-essiv:sha256 +0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0+0 0 /dev/debian/tmptest 0"

Should this be fixed in dm-crypt or in kstrtou8? A fix in kstrtou8 could 
be more appropriate, but we don't know how many other kernel parts depend 
on this "skip plus" behavior...

Mikulas
