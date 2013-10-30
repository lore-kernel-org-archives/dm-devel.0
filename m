From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/2] dm-crypt: Properly handle extra
	key	string in initialization
Date: Wed, 30 Oct 2013 03:23:46 +0000
Message-ID: <20131030032346.GA18263@agk-dp.fab.redhat.com>
References: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
	<1382998864-10380-1-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382998864-10380-1-git-send-email-gmazyland@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Oct 28, 2013 at 11:21:03PM +0100, Milan Broz wrote:
> Example where key string contains main key K, whitening key
> Kw and IV seed Kiv:
> 
> |     K       |   Kiv   |       Kw       |
> |--------------- key_size ---------------|
> |             |-----key_extra_size-------|
> |  [1 key]    | [1 key] |     [1 key]    | => key_parts = 3
 
Ah, part of the confusion is because this patch does not actually support 
this case yet, does it?  That's for the next patch!

Can we update this patch header accordingly?
Maybe even move those ASCII diagrams into the code as comments.

Alasdair
