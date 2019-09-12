From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 5/5] dm-bufio: introduce a global cache
 replacement
Date: Thu, 12 Sep 2019 13:59:00 +0200
Message-ID: <03876828-40a1-7adc-d40c-939853e8259c@redhat.com>
References: <20190912084550.401229120@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190912084550.401229120@debian-a64.vm>
Content-Language: en-MW
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Martijn Coenen <maco@android.com>, Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: maco@google.com, dariofreni@google.com, jiyong@google.com, kernel-team@android.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Mikulas,

please use list_move instead of list_del/list_add pairs.

Heinz
