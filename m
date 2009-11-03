From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [PATCH 03/18] Export outsz() and outhnt() for	modules
Date: Tue, 03 Nov 2009 12:04:30 +0100
Message-ID: <4AF00E3E.3050505@redhat.com>
References: <1257171622-8380-1-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-2-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-3-git-send-email-zkabelac@redhat.com>
	<1257171622-8380-4-git-send-email-zkabelac@redhat.com>
	<20091102145420.GE13375@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091102145420.GE13375@agk-dp.fab.redhat.com>
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

Dne 2.11.2009 15:54, Alasdair G Kergon napsal(a):
> On Mon, Nov 02, 2009 at 03:20:07PM +0100, Zdenek Kabelac wrote:
>> Adding macro outsz() for out_size() and outhnt() for out_hint()
>> that checks for error in a similar way as outf() does for out_text()
>  
> Ack.
> 
> outhint rather than outhnt perhaps?

In that case probably outsize() as well with outhint() ?

Zdenek
