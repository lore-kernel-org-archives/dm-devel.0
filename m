From: Eugene Syromiatnikov <esyr@redhat.com>
Subject: Re: [PATCH 3/3] dm-ioctl: report event number in
 DM_LIST_DEVICES
Date: Sun, 17 Sep 2017 04:41:27 +0200
Message-ID: <20170917023849.GA4094@asgard.redhat.com>
References: <20170509191028.6898-1-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170509191028.6898-1-agrover@redhat.com>
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
Cc: agrover@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

> +			event_nr = align_ptr(((void *) (nl + 1)) + strlen(hc->name) + 1);
If my understanding is correct, (nl + 1) differs between 32-bit and
64-bit kernels (as the structure contains of one 8-byte and one 4-byte field),
so this logic is probably broken for compat.
