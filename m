From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: PATCH - multipath UUID
Date: Fri, 30 Sep 2005 00:16:44 +0200
Message-ID: <1128032204.6536.45.camel@zezette>
References: <433C1063.3070202@redhat.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <433C1063.3070202@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On jeu, 2005-09-29 at 17:03 +0100, Patrick Caulfield wrote:
> If you use aliases to rename the multipath devices to something sensible you
> lose the WWIDs, this patch stores them as the device-mapper UUID and retrieves
> them so they can be displayed using multipath -l.
> --
How imaginative !
Applied, with thanks,
cvaroqui
