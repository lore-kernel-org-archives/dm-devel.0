From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] iscsi: do not wait for IOs in dm shrinker
Date: Tue, 24 Mar 2020 02:29:54 -0700
Message-ID: <20200324092954.GA16679@infradead.org>
References: <20200304163953.578311-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200304163953.578311-1-krisman@collabora.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: Tahsin Erdogan <tahsin@google.com>, snitzer@redhat.com, Khazhismel Kumykov <khazhy@google.com>, dm-devel@redhat.com, kernel@collabora.com, agk@redhat.com
List-Id: dm-devel.ids

The Subject is wrong - this is a device mapper patch, not an iscsi
one.
