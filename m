From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] libmpathcmd: Fixup FSF address
Date: Fri, 3 Jun 2016 22:56:27 +0200
Message-ID: <9c66fa50-a9cf-cfd9-175f-4839e3af75cd@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.com>, device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

Hannes Reinecke wrote:

> Our build system complained that the header file still
> refers to the old FSF snail mail address.

This is a pointless change.

scripts/checkpatch.pl from kernel sources already is warning about it:
"Do not include the paragraph about writing to the Free Software Foundation's
mailing address from the sample GPL notice. The FSF has changed addresses in
the past, and may do so again. Linux already includes a copy of the GPL."

Much better is replace all occurrences from:
"if not, write to the Free Software Foundation, Inc.,
59 Temple Place - Suite 330, Boston, MA  02111-1307, USA."

to:
"if not, see <http://www.gnu.org/licenses/>."

> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  libmpathcmd/mpath_cmd.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
> index 6d80a2f..4ec0291 100644
> --- a/libmpathcmd/mpath_cmd.h
> +++ b/libmpathcmd/mpath_cmd.h
> @@ -15,7 +15,7 @@
>   *
>   * You should have received a copy of the GNU Lesser General Public
>   * License along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301,
>   * USA.
