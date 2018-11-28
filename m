From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 1/2] libmultipath: cleanup
 pthread_cleanup_pop call
Date: Wed, 28 Nov 2018 10:02:05 +0100
Message-ID: <4169de593d8e13c7415efd34b5a9ab576a4bc208.camel@suse.de>
References: <1543385604-25453-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1543385604-25453-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2018-11-28 at 00:13 -0600,  Benjamin Marzinski  wrote:
> pthread_cleanup_push() and pthread_cleanup_pop() must be called in
> the
> same lexical scope.  In uevent_listen(), the pthread_cleanup_pop()
> call
> to cleanup the udev monitor is called in a nested 'if' block, within
> the block where pthread_cleanup_push() is called.  Since this is a
> single-statement if block, it doesn't actually cause any problems,
> but
> it should be fixed anyways.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
