From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Avoid that reloading a map sporadically triggers I/O
	errors
Date: Fri, 18 Nov 2016 16:43:24 -0500
Message-ID: <20161118214324.GA5953@redhat.com>
References: <85315cb2-6908-70c6-78b7-06b6c1071f6b@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <85315cb2-6908-70c6-78b7-06b6c1071f6b@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Nov 18 2016 at  4:33pm -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> Avoid that reloading a map while there are no paths triggers a flush
> and hence unwanted I/O errors if 'queue_if_no_path' is enabled.

I assume you meant: "if 'queue_if_no_path' is _not_ enabled." ?
