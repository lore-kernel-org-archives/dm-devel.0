From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] libmpathcmd: Fixup FSF address
Date: Fri,  3 Jun 2016 08:41:57 +0200
Message-ID: <1464936117-792-1-git-send-email-hare@suse.de>
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
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

Our build system complained that the header file still
refers to the old FSF snail mail address.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathcmd/mpath_cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathcmd/mpath_cmd.h b/libmpathcmd/mpath_cmd.h
index 6d80a2f..4ec0291 100644
--- a/libmpathcmd/mpath_cmd.h
+++ b/libmpathcmd/mpath_cmd.h
@@ -15,7 +15,7 @@
  *
  * You should have received a copy of the GNU Lesser General Public
  * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301,
  * USA.
  */
 
-- 
2.6.6
