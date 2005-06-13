From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: How about having multipathd re-enable a currently
	disabled (bypas sed) path group ...
Date: Mon, 13 Jun 2005 10:29:43 +0200
Message-ID: <20050613082942.GM17296@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321AA8F@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AA8F@SRMANNING.eng.emc.com>
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

On 2005-06-10T12:50:44, "goggin, edward" <egoggin@emc.com> wrote:

> ... whenever any path in the path group tests successfully, that is,
> the path checker for the path returns PATH_UP (that is, not
> PATH_DOWN, PATH_SHAKY, or -1)?

That would _immediately_ cause a failback to said group. Which is what a
certain storage vendor also doesn't want. ;-)

If anything, I'd assume a choice of:

a) Reenable "immediately"
b) Reenable after N seconds in which no new failures have been detected
   (giving the fabric a delay to stabilize)
c) Reenable manually only.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"
