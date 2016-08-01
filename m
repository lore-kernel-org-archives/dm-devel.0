From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [RFC] [PATCH] add serial keyword to the weightedpath
 prioritizer
Date: Mon, 1 Aug 2016 09:02:21 -0700
Message-ID: <577b156f-4b6f-ae00-10ba-d5b65fbe2ae7@sandisk.com>
References: <CABr-Gndh4LLgd=T00GdtwNVrFgL7Te91BwjZ0Dh4uYyDi3c9bA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gndh4LLgd=T00GdtwNVrFgL7Te91BwjZ0Dh4uYyDi3c9bA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/31/2016 12:26 PM, Christophe Varoqui wrote:
> Can you review this patch, adding a new 'serial' keyword to the
> weightedpath prioritizer.

Is the following part of the patch intended?

         } else if (!strcmp(regex, WWN)) {
-               if (build_wwn_path(pp, path, FILE_NAME_SIZE) != 0) {
+               if (build_serial_path(pp, path, FILE_NAME_SIZE) != 0) {

Additionally, have you considered to apply the mulitpathd -> multipathd 
spelling fix in this patch as a separate patch?

Thanks,

Bart.
