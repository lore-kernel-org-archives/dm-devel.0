From: Bowe Strickland <bowe@redhat.com>
Subject: Re: Snapshots and resizing
Date: Thu, 7 Dec 2006 12:02:26 -0500
Message-ID: <20061207120226.0e3af1f5@station192.example.com>
References: <a71bd89a0612042224obc42c63ld5656752e1d3c03d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a71bd89a0612042224obc42c63ld5656752e1d3c03d@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

-------------------------- thus spake "Dan Kegel" <dank06@kegel.com> ---
> Inquiring minds want to know:
> if you take a snapshot of an ext3 volume,
> and then you resize the volume (say, you need to add a disk),
> does the snapshot remain valid?


iirc, resizing is not allowed if there's an active snapshot...
